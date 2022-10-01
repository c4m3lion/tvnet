import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  String videoUrl = "";

  VideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  bool isLoading = false;

  void initVideo() async {
    isLoading = true;
    videoPlayerController = VideoPlayerController.network(
      widget.videoUrl,
    );
    await videoPlayerController.initialize();
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        isLive: true,
        aspectRatio: videoPlayerController.value.aspectRatio,
        allowedScreenSleep: false,
        allowPlaybackSpeedChanging: false,
        allowFullScreen: false,
        showControls: false,
        useRootNavigator: false);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    chewieController?.dispose();
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading || chewieController == null
        ? CircularProgressIndicator()
        : Chewie(
            controller: chewieController!,
          );
  }
}
