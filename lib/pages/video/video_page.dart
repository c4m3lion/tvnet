import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvnet/components/build_epg.dart';
import 'package:tvnet/components/favorite_button.dart';
import 'package:tvnet/services/my_functions.dart';
import 'package:video_player/video_player.dart';

import '../../classes/Channel.dart';
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

  FocusNode _videoFocus = FocusNode();

  Future<void> initVideo(String url) async {
    chewieController?.dispose();
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
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      isLive: true,
      aspectRatio: 16 / 9,
      looping: true,
      showControls: false,
    );
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadChannel() async {
    if (widget.channel != null) {
      globals.setCurrentChannelId(widget.channel!);
    }
    await initVideo(await loadUrl(globals.currentChannel));
  }

  void refreshPage() {}

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
        autofocus: true,
        canRequestFocus: !isControl,
        onKey: (node, event) {
          if (event.runtimeType.toString() == 'RawKeyDownEvent') {
            if (!isControl &&
                (event.logicalKey == LogicalKeyboardKey.select ||
                    event.logicalKey == LogicalKeyboardKey.enter)) {
              setState(() {
                isControl = true;
              });
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        focusNode: _videoFocus,
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
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: isLoading || chewieController == null
              ? const CircularProgressIndicator()
              : Chewie(
                  controller: chewieController!,
                ),
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
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 200,
                                  color: Colors.amber,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Text('Modal BottomSheet'),
                                        ElevatedButton(
                                          child:
                                              const Text('Close BottomSheet'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  globals.currentChannel.icon,
                                  width: 60,
                                ),
                              ),
                              title: Text(globals.currentChannel.name),
                              subtitle: globals.epgs.length > 0
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
            : null,
      ),
    );
  }
}
