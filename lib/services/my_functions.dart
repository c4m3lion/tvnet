import 'package:flutter/material.dart';

class MyPrint {
  static void printWarning(String text) {
    print('\x1B[33m$text\x1B[0m');
  }

  static void printError(String text) {
    print('\x1B[31m$text\x1B[0m');
  }

  static void showDiolog(BuildContext context, String err) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(err),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void dialog(BuildContext context, String _title, String _content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_title),
          content: Text(_content),
          actions: [
            ElevatedButton(
              autofocus: true,
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
