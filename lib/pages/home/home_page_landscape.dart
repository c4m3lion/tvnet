import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tvnet/components/build_epg.dart';
import 'package:tvnet/pages/home/home_components/build_category.dart';
import 'package:tvnet/pages/home/setting/setting_page.dart';
import 'package:tvnet/pages/video/vlc_player_page.dart';
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          controlPanel(),
          Expanded(
            child: loadPage(),
          ),
        ],
      ),
    );
  }

  Widget loadPage() {
    switch (globals.selectedPage) {
      case 0:
        return buildMainPage();
      case 1:
        return SettingPage();
      default:
        return buildMainPage();
    }
  }

  Widget buildMainPage() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
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
    );
  }

  Widget controlPanel() {
    return Container(
      width: 60,
      child: Material(
        color: panelColor,
        child: NavigationRail(
          backgroundColor: panelColor,
          onDestinationSelected: (int index) {
            setState(() {
              globals.selectedPage = index;
            });
          },
          leading: InkWell(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VlcPlayerPage(),
                ),
              ),
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                SizedBox(
                  height: 34,
                  width: double.infinity,
                  child: Center(
                    child: ImageIcon(
                      AssetImage("assets/images/back-icon.png"),
                      size: 60,
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                ),
              ],
            ),
          ),
          destinations: const [
            NavigationRailDestination(
              icon: ImageIcon(
                AssetImage("assets/images/channels-icon.png"),
              ),
              selectedIcon: Icon(Icons.tv),
              label: Text('First'),
            ),
            NavigationRailDestination(
              icon: ImageIcon(
                AssetImage("assets/images/settings-icon.png"),
              ),
              selectedIcon: Icon(Icons.settings),
              label: Text('Second'),
            ),
          ],
          selectedIndex: globals.selectedPage,
          trailing: Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: StreamBuilder(
                stream: Stream.periodic(const Duration(minutes: 1)),
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      DateFormat('hh:mm').format(DateTime.now()),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
