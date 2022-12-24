import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tvnet/components/confirmation_component.dart';
import 'package:tvnet/pages/home/home_page_landscape.dart';
import 'package:tvnet/pages/home/home_page_portrait.dart';

import '../../services/my_functions.dart' as func;
import '../../services/my_globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int initialScrollChannel = 0;

  void loadCategory(int index) {
    globals.setCurrentTempCategoryId(index);
    setState(() {
      globals.categoryChannels =
          func.loadByCategoryChannels(categoryId: globals.categories[index].id);
      initialScrollChannel = globals.categoryChannels
          .indexWhere((c) => c.name == globals.currentChannel.name);
      if (initialScrollChannel == -1) {
        initialScrollChannel = 0;
      }
    });
    print("AUYYESYYSEYSYDFASDAYSD");
    print(initialScrollChannel);
    Future.delayed(const Duration(milliseconds: 500), () {
      globals.itemScrollController.scrollTo(
          index: initialScrollChannel,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOutCubic);
    });
  }

  void findchannel() {
    initialScrollChannel = globals.categoryChannels
        .indexWhere((c) => c.name == globals.currentChannel.name);
    if (initialScrollChannel == -1) {
      initialScrollChannel = 0;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      globals.itemScrollController
          .scrollTo(
              index: initialScrollChannel,
              duration: Duration(seconds: 1),
              curve: Curves.easeInOutCubic)
          .then((value) => {
                globals.itemScrollController.scrollTo(
                    index: initialScrollChannel,
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOutCubic),
              });
    });
  }

  @override
  void initState() {
    globals.currentTempCategoryId = globals.currentCategoryId;
    globals.categoryChannels = func.loadByCategoryChannels();
    globals.itemScrollController = ItemScrollController();
    findchannel();
    super.initState();
  }

  void reseting() {
    globals.currentTempCategoryId = globals.currentCategoryId;
  }

  @override
  void dispose() {
    reseting();

    globals.itemScrollController = ItemScrollController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return WillPopScope(
      onWillPop: () async {
        return confirmation(
            context: context,
            title: 'Are you sure?',
            body: 'Do you want to exit an App');
      },
      child: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            switch (orientation) {
              case Orientation.landscape:
                SystemChrome.setEnabledSystemUIMode(
                    SystemUiMode.immersiveSticky);
                return HomePageLandScape(
                  channels: globals.categoryChannels,
                  loadCategory: loadCategory,
                  scrollPosition: initialScrollChannel,
                );
              case Orientation.portrait:
                // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                return HomePagePortrait(
                  channels: globals.categoryChannels,
                  loadCategory: loadCategory,
                  scrollPosition: initialScrollChannel,
                );
            }
          },
        ),
      ),
    );
  }
}
