import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<bool> confirmation(
    {required BuildContext context,
    required String title,
    required String body}) async {
  return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              autofocus: true,
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No').tr(),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes').tr(),
            ),
          ],
        ),
      )) ??
      false;
}
