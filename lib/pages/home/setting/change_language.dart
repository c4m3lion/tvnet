import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void languageModal(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 600,
        child: Center(
          child: ListView(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Image.asset(
                    'icons/flags/png/az.png',
                    package: 'country_icons',
                    width: 60,
                  ),
                  onTap: () => {
                    context.setLocale(Locale('az')),
                    Navigator.pop(context),
                  },
                  title: Text("Azərbaycan"),
                  trailing: Text("AZ"),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Image.asset(
                    'icons/flags/png/sa.png',
                    package: 'country_icons',
                    width: 60,
                  ),
                  onTap: () => {
                    context.setLocale(Locale('ar')),
                    Navigator.pop(context),
                  },
                  title: Text("عربي"),
                  trailing: Text("AR"),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Image.asset(
                    'icons/flags/png/gb.png',
                    package: 'country_icons',
                    width: 60,
                  ),
                  onTap: () => {
                    context.setLocale(Locale('en')),
                    Navigator.pop(context),
                  },
                  title: Text("English"),
                  trailing: Text("EN"),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Image.asset(
                    'icons/flags/png/ua.png',
                    package: 'country_icons',
                    width: 60,
                  ),
                  onTap: () => {
                    context.setLocale(Locale('uk')),
                    Navigator.pop(context),
                  },
                  title: Text("Україна"),
                  trailing: Text("UK"),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Image.asset(
                    'icons/flags/png/ru.png',
                    package: 'country_icons',
                    width: 60,
                  ),
                  onTap: () => {
                    context.setLocale(Locale('ru')),
                    Navigator.pop(context),
                  },
                  title: Text("Russian"),
                  trailing: Text("RU"),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
