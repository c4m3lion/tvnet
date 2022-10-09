import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvnet/pages/home/home_page_landscape.dart';
import 'package:tvnet/pages/home/home_page_portrait.dart';

import '../../classes/Channel.dart';
import '../../services/my_functions.dart' as func;
import '../../services/my_globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Channel> categoryChannels;

  void loadCategory(int index) {
    globals.setCurrentCategoryId(index);
    setState(() {
      categoryChannels = func.loadByCategoryChannels();
    });
  }

  @override
  void initState() {
    categoryChannels = func.loadByCategoryChannels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit an App'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('Yes'),
                  ),
                ],
              ),
            )) ??
            false;
      },
      child: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            switch (orientation) {
              case Orientation.landscape:
                SystemChrome.setEnabledSystemUIMode(
                    SystemUiMode.immersiveSticky);
                return HomePageLandScape(
                  channels: categoryChannels,
                  loadCategory: loadCategory,
                );
              case Orientation.portrait:
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                return HomePagePortrait(
                  channels: categoryChannels,
                  loadCategory: loadCategory,
                );
            }
          },
        ),
      ),
    );
  }
}
