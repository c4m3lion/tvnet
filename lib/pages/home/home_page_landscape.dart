import 'package:flutter/material.dart';
import 'package:tvnet/components/build_control_panel.dart';
import 'package:tvnet/components/build_epg.dart';
import 'package:tvnet/pages/home/home_components/build_category.dart';
import 'package:tvnet/services/color_service.dart';

import '../../classes/Channel.dart';
import '../../services/my_globals.dart' as globals;
import 'home_components/build_channel.dart';

class HomePageLandScape extends StatefulWidget {
  List<Channel> channels;
  void Function(int index) loadCategory;
  HomePageLandScape(
      {Key? key, required this.channels, required this.loadCategory})
      : super(key: key);

  @override
  State<HomePageLandScape> createState() => _HomePageLandScapeState();
}

class _HomePageLandScapeState extends State<HomePageLandScape>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  Channel? selectedChannel;
  void selectChannel(Channel channel) {
    selectedChannel = channel;
    setState(() {});
  }

  Channel get getChannel {
    return selectedChannel ?? globals.currentChannel;
  }

  void refreshPage() {
    setState(() {});
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          controlPanel(context, tabController),
          SizedBox(
            width: 160,
            child: buildCategories(
              loadCategory: widget.loadCategory,
            ),
          ),
          SizedBox(
            width: 280,
            height: double.infinity,
            child: Material(
              color: channelSectionColor,
              child: buildChannels(
                refreshPage: refreshPage,
                channels: widget.channels,
                selectChannel: selectChannel,
              ),
            ),
          ),
          Expanded(
            child: BuildEpg(
              channel: getChannel,
            ),
          ),
        ],
      ),
    );
  }
}
