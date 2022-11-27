import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            Shortcuts(
              shortcuts: {
                SingleActivator(LogicalKeyboardKey.select):
                    const ActivateIntent(),
                SingleActivator(LogicalKeyboardKey.enter):
                    const ActivateIntent(),
              },
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
            ),
            Shortcuts(
              shortcuts: {
                SingleActivator(LogicalKeyboardKey.select):
                    const ActivateIntent(),
                SingleActivator(LogicalKeyboardKey.enter):
                    const ActivateIntent(),
              },
              child: TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: new Text('Yes'),
              ),
            ),
          ],
        ),
      )) ??
      false;
}
