import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvnet/pages/video/video_player.dart';
import 'package:tvnet/services/my_data.dart';
import 'package:tvnet/services/my_functions.dart';

class VideoPage extends StatefulWidget {
  String? channelId;
  VideoPage({Key? key, this.channelId}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  Future<Channel> loadChannel() async {
    if (widget.channelId != null) {
      MyData().setCurrentChannelId(widget.channelId!);
    }
    var temp = MyData().findChannelById(MyData.currentChannelId);

    if (temp == Channel.empty()) {
      throw ("channel not found: ${MyData.currentChannelId}");
    }
    temp.url ??= await MyFunctions().getPlayBack(channelId: temp.id);
    return temp;
  }

  void refreshPage() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              return Container(
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    bildMainFrame(),
                    Expanded(
                      child: Container(
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              );
            }
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
            return Center(child: bildMainFrame());
          },
        ),
      ),
    );
  }

  Widget bildMainFrame() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: FutureBuilder<Channel>(
        future: loadChannel(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading....');
            default:
              if (snapshot.hasError) {
                print(snapshot.error);
                // MyMessage.showSnack(
                //     context: context,
                //     text: "channel not found: ${MyData.currentChannelId}");
                return Icon(Icons.error);
              } else {
                return VideoPlayer(
                  videoUrl: snapshot.data!.url!,
                );
              }
          }
        },
      ),
    );
  }
}
