import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../services/my_globals.dart' as globals;

Widget buildCategories(
    {required void Function(int index) loadCategory, bool willPop = false}) {
  return ListView.builder(
    itemCount: globals.categories.length,
    itemBuilder: (context, index) {
      return Focus(
        canRequestFocus: false,
        onKey: (node, event) {
          if (index >= globals.categories.length - 1 &&
              event.logicalKey == LogicalKeyboardKey.arrowDown) {
            return KeyEventResult.handled;
          }
          if (index <= 0 && event.logicalKey == LogicalKeyboardKey.arrowUp) {
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: ListTile(
          onTap: () {
            loadCategory(index);
            if (willPop) Navigator.pop(context);
          },
          selected: index == globals.currentTempCategoryId,
          title: Text(
            globals.categories[index].name.tr(),
          ),
        ),
      );
    },
  );
}
