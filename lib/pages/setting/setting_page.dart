import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvnet/pages/setting/setting_page_landscape.dart';
import 'package:tvnet/pages/setting/setting_page_portrait.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: OrientationBuilder(
        builder: (context, orientation) {
          switch (orientation) {
            case Orientation.landscape:
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
              return SettingLandscape();
            case Orientation.portrait:
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              return SettingPagePortrait();
          }
        },
      ),
    );
  }
}
