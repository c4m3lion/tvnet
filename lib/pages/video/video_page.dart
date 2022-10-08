import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  bool isLoading = false;

  Future<void> initVideo(String url) async {
    isLoading = true;
    videoPlayerController = VideoPlayerController.network(
      url,
    );
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      isLive: true,
      aspectRatio: 16 / 9,
      allowedScreenSleep: false,
      allowPlaybackSpeedChanging: false,
      allowFullScreen: false,
      showControls: true,
      useRootNavigator: false,
    );
    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadChannel() async {
    if (widget.channel != null) {
      globals.setCurrentChannelId(widget.channel!);
    }
    await initVideo(await globals.currentChannel.getUrl());
  }

  void refreshPage() {}

  @override
  void initState() {
    loadChannel();
    super.initState();
  }

  @override
  void dispose() {
    chewieController?.dispose();
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/home");
        return false;
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
                    Stack(
                      children: [
                        bildMainFrame(),
                        IconButton(
                            onPressed: () => {
                                  Navigator.pushReplacementNamed(
                                      context, "/home")
                                },
                            icon: Icon(Icons.arrow_back_ios))
                      ],
                    ),
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
                  ],
                );
              }
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
              return Center(child: bildMainFrame());
            },
          ),
        ),
      ),
    );
  }

  Widget bildMainFrame() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: isLoading || chewieController == null
          ? const CircularProgressIndicator()
          : Chewie(
              controller: chewieController!,
            ),
    );
  }
}
