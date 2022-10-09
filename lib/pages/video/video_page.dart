import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvnet/components/build_epg.dart';
import 'package:tvnet/components/favorite_button.dart';
import 'package:tvnet/pages/video/video_components/number_overlay.dart';
import 'package:tvnet/services/my_functions.dart';
import 'package:video_player/video_player.dart';

import '../../classes/Channel.dart';
import '../../components/build_aspect_ratio.dart';
import '../../services/my_globals.dart' as globals;

class VideoPage extends StatefulWidget {
  Channel? channel;
  VideoPage({Key? key, this.channel}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  bool isLoading = false;
  bool isControl = false;

  int currentNumber = 0;

  FocusNode _videoFocus = FocusNode();

  double calculateAspect() {
    var aspects = globals.aspectRatio.split('/');
    return double.parse(aspects[0]) / double.parse(aspects[1]);
  }

  Future<void> initVideo(String url) async {
    videoPlayerController?.dispose();
    isLoading = true;

    videoPlayerController = VideoPlayerController.network(
      url,
      formatHint: VideoFormat.hls,
      httpHeaders: {
        'oms-client': globals.token,
      },
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    );
    await videoPlayerController!.initialize();
    loadChewie();
    setState(() {
      isLoading = false;
    });
  }

  void loadChewie() {
    chewieController?.dispose();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      isLive: true,
      aspectRatio: calculateAspect(),
      looping: true,
      showControls: false,
    );
    setState(() {});
  }

  Future<void> loadChannel() async {
    if (widget.channel != null) {
      globals.setCurrentChannelId(widget.channel!);
    }
    await initVideo(await loadUrl(globals.currentChannel));
  }

  void channelChanged(Channel channel) async {
    globals.setCurrentChannelId(channel);
    await initVideo(await loadUrl(globals.currentChannel));
  }

  void refreshPage() {}

  void numberKeyPressed(int id) async {
    currentNumber = currentNumber * 10 + id;
    setState(() {});
    var temp = currentNumber;
    await Future.delayed(Duration(seconds: 3));
    if (currentNumber == temp) {
      globals.setCurrentCategoryId(0);
      try {
        globals.currentChannel = globals.findChannelByLcn(currentNumber);
      } catch (e) {
        if (mounted) {
          showSnack(context, e.toString());
        }
      }
      currentNumber = 0;
      setState(() {});
      channelChanged(globals.currentChannel);
    }
  }

  @override
  void initState() {
    loadChannel();
    super.initState();
  }

  @override
  void dispose() {
    _videoFocus.dispose();
    chewieController?.dispose();
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isControl) {
          setState(() {
            isControl = false;
          });
          await Future.delayed(Duration(seconds: 1));
          FocusScope.of(context).requestFocus(_videoFocus);
        } else {
          Navigator.pushReplacementNamed(context, "/home");
        }
        return false;
      },
      child: Focus(
        canRequestFocus: false,
        onKey: (node, event) {
          if (event.runtimeType.toString() == 'RawKeyDownEvent') {
            if (!isControl) {
              if (event.logicalKey == LogicalKeyboardKey.select ||
                  event.logicalKey == LogicalKeyboardKey.enter) {
                setState(() {
                  isControl = true;
                });
                return KeyEventResult.handled;
              }
            }
            print(event.logicalKey);
          }
          if (isNumeric(event.logicalKey.keyLabel) &&
              event.runtimeType.toString() == 'RawKeyDownEvent') {
            print(event.logicalKey.keyLabel);
            numberKeyPressed(int.parse(event.logicalKey.keyLabel));
          }
          return KeyEventResult.ignored;
        },
        child: SafeArea(
          child: Scaffold(
            body: OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      bildMainFrame(),
                      Card(
                        child: ListTile(
                          leading: Image.network(globals.currentChannel.icon),
                          title: Text(globals.currentChannel.name),
                          trailing: favoriteButton(
                            channel: globals.currentChannel,
                            onAdd: () => {
                              addFavorite(globals.currentChannel)
                                  .then((value) => setState(() {})),
                            },
                            onRemove: () => {
                              removeFavorite(globals.currentChannel)
                                  .then((value) => setState(() {})),
                            },
                          ),
                        ),
                      ),
                      Expanded(
                          child: BuildEpg(channel: globals.currentChannel)),
                    ],
                  );
                }
                SystemChrome.setEnabledSystemUIMode(
                    SystemUiMode.immersiveSticky);
                return Center(child: bildMainFrame());
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget bildMainFrame() {
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: isLoading || chewieController == null
              ? Align(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                )
              : Chewie(
                  controller: chewieController!,
                ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: numberOverlay(currentNumber),
        ),
        buildControl(),
      ],
    );
  }

  Widget buildControl() {
    return GestureDetector(
      onTap: () => {
        setState(
          () {
            isControl = !isControl;
          },
        ),
      },
      child: Container(
        color: Colors.transparent,
        child: isControl
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          padding: EdgeInsets.all(16),
                          onPressed: () => {
                            Navigator.pushReplacementNamed(context, "/home"),
                          },
                          icon: Icon(Icons.arrow_back_ios),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(16),
                          onPressed: () => {
                            loadAspectRatios(
                              context: context,
                              onSelected: loadChewie,
                            ),
                          },
                          icon: Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Card(
                            child: ListTile(
                              leading: SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(globals.currentChannel.lcn.toString()),
                                    SizedBox(
                                      width: 60,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl: globals.currentChannel.icon,
                                          placeholder: (context, url) =>
                                              Icon(Icons.image),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.broken_image),
                                          width: 60,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              title: Text(globals.currentChannel.name),
                              subtitle: globals.epgs.isNotEmpty
                                  ? Text(globals
                                      .epgs[globals.currentActiveEpgId].title)
                                  : null,
                              trailing: favoriteButton(
                                autoFocus: true,
                                channel: globals.currentChannel,
                                onAdd: () => {
                                  addFavorite(globals.currentChannel)
                                      .then((value) => setState(() {})),
                                },
                                onRemove: () => {
                                  removeFavorite(globals.currentChannel)
                                      .then((value) => setState(() {})),
                                },
                                isArrowWork: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Focus(
                autofocus: true,
                focusNode: _videoFocus,
                onKey: (node, event) {
                  if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                    channelChanged(globals.loadNextChannel());
                    setState(() {});
                  }
                  if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                    channelChanged(globals.loadPreviousChannel());
                    setState(() {});
                  }
                  return KeyEventResult.ignored;
                },
                child: Container(),
              ),
      ),
    );
  }
}
