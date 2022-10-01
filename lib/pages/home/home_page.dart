import 'package:flutter/material.dart';
import 'package:tvnet/pages/video/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoPlayer(
        videoUrl: "",
      ),
    );
  }
}
