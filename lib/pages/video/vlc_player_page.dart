import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:tvnet/pages/video/video_player_service.dart';

import '../../classes/Channel.dart';
import '../../components/build_aspect_ratio.dart';
import '../../components/build_epg.dart';
import '../../components/favorite_button.dart';
import '../../services/my_functions.dart' as func;
import '../../services/my_globals.dart' as globals;
import 'video_components/number_overlay.dart';

class VlcPlayerPage extends StatefulWidget {
  Channel? channel;
  VlcPlayerPage({Key? key, this.channel}) : super(key: key);

  @override
  State<VlcPlayerPage> createState() => _VlcPlayerPageState();
}

class _VlcPlayerPageState extends State<VlcPlayerPage> {
  VlcPlayerController? controller;
  final double playerWidth = 640;
  final double playerHeight = 360;

  bool isControl = false;

  int currentNumber = 0;

  final FocusNode _videoFocus = FocusNode();

  Future<void> initVideo(String url) async {
    await stopPlayer();

    controller =
        VlcPlayerController.network(url, hwAcc: HwAcc.disabled, autoPlay: true);
    //await videoPlayerController!.initialize();
    //loadChewie();
    setState(() {});
  }

  Future<void> loadChannel() async {
    setState(() {});
    if (widget.channel != null) {
      globals.setCurrentChannelId(widget.channel!);
    }
    await initVideo(await func.loadUrl(globals.currentChannel));
    setState(() {});
  }

  void channelChanged(Channel channel) async {
    globals.setCurrentChannelId(channel);
    var url = await func.loadUrl(globals.currentChannel);
    initVideo(url);
    setState(() {});
  }

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
          func.showSnack(context, e.toString());
        }
      }
      currentNumber = 0;
      setState(() {});
      channelChanged(globals.currentChannel);
    }
  }

  void aspectChange() {
    setState(() {});
  }

  Future<void> stopPlayer() async {
    if (controller != null) {
      await controller!.stop();
    }
    await controller?.stopRendererScanning();
    await controller?.dispose();
  }

  @override
  void initState() {
    loadChannel();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    if (controller != null) {
      await controller!.stop();
    }
    await controller?.stopRendererScanning();
    await controller?.dispose();
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
          if (controller != null) {
            await controller!.stop();
          }
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
          if (func.isNumeric(event.logicalKey.keyLabel) &&
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
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: bildMainFrame(),
                      ),
                      Card(
                        child: ListTile(
                          leading: Image.network(globals.currentChannel.icon),
                          title: Text(globals.currentChannel.name),
                          trailing: favoriteButton(
                            channel: globals.currentChannel,
                            onAdd: () => {
                              func
                                  .addFavorite(globals.currentChannel)
                                  .then((value) => setState(() {})),
                            },
                            onRemove: () => {
                              func
                                  .removeFavorite(globals.currentChannel)
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
                return SizedBox(width: double.infinity, child: bildMainFrame());
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
        Align(
          alignment: Alignment.center,
          child: controller == null
              ? CircularProgressIndicator()
              : VlcPlayer(
                  aspectRatio: calculateAspect(),
                  controller: controller!,
                  placeholder: const Center(
                    child: CircularProgressIndicator(),
                  ),
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
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
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
                              onSelected: aspectChange,
                            ),
                          },
                          icon: Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ),
                  !isPortrait
                      ? Expanded(
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
                                          Text(globals.currentChannel.lcn
                                              .toString()),
                                          SizedBox(
                                            width: 60,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    globals.currentChannel.icon,
                                                placeholder: (context, url) =>
                                                    Icon(Icons.image),
                                                errorWidget: (context, url,
                                                        error) =>
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
                                            .epgs[globals.currentActiveEpgId]
                                            .title)
                                        : null,
                                    trailing: favoriteButton(
                                      autoFocus: true,
                                      channel: globals.currentChannel,
                                      onAdd: () => {
                                        func
                                            .addFavorite(globals.currentChannel)
                                            .then((value) => setState(() {})),
                                      },
                                      onRemove: () => {
                                        func
                                            .removeFavorite(
                                                globals.currentChannel)
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
                      : Container(),
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
