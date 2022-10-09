import 'package:flutter/material.dart';
import 'package:tvnet/pages/home/home_components/build_category.dart';
import 'package:tvnet/pages/home/home_components/build_channel.dart';
import 'package:tvnet/pages/home/setting/setting_page.dart';

import '../../classes/Channel.dart';
import '../../services/my_globals.dart' as globals;

class HomePagePortrait extends StatefulWidget {
  List<Channel> channels;
  void Function(int index) loadCategory;
  HomePagePortrait(
      {Key? key, required this.channels, required this.loadCategory})
      : super(key: key);

  @override
  State<HomePagePortrait> createState() => _HomePagePortraitState();
}

class _HomePagePortraitState extends State<HomePagePortrait> {
  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          globals.selectedPage == 0
              ? globals.getCurrentCategory.name
              : "Settings",
        ),
      ),
      drawer: Drawer(
        width: 200,
        child: buildCategories(
          loadCategory: widget.loadCategory,
          willPop: true,
        ),
      ),
      body: loadPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: globals.selectedPage,
        onTap: (index) => {
          setState(() {
            globals.selectedPage = index;
          }),
        },
      ),
    );
  }

  Widget loadPage() {
    switch (globals.selectedPage) {
      case 0:
        return buildChannels(
          refreshPage: refreshPage,
          channels: widget.channels,
        );
      case 1:
        return SettingPage();
      default:
        return buildChannels(
          refreshPage: refreshPage,
          channels: widget.channels,
        );
    }
  }
}
