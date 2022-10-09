import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tvnet/components/confirmation_component.dart';
import 'package:tvnet/services/my_globals.dart';

import '../../../components/build_aspect_ratio.dart';
import '../../../services/my_functions.dart';
import 'change_language.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: ListTile(
            onTap: () => {},
            title: Text(name),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () => {
              languageModal(context),
            },
            title: const Text("Change app language").tr(),
            trailing: Text(context.locale.languageCode.toUpperCase()),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () => {
              loadAspectRatios(context: context),
            },
            title: Text("Aspect Ratio").tr(),
            trailing: Text(aspectRatio),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () async => {
              if (await confirmation(
                context: context,
                title: "Are you sure?",
                body: "Do you really want to log out?",
              ))
                {
                  logOut(context),
                }
            },
            title: const Text("Log out").tr(),
          ),
        ),
      ],
    );
  }
}
