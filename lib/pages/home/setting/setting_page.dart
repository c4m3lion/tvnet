import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
        InkWell(
          onTap: () => {
            languageModal(context),
          },
          child: Card(
            child: ListTile(
              title: const Text("Change app language").tr(),
              trailing: Text(context.locale.languageCode.toUpperCase()),
            ),
          ),
        ),
      ],
    );
  }
}
