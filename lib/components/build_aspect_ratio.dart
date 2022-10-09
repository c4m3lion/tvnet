import 'package:flutter/material.dart';
import 'package:tvnet/services/my_globals.dart';

void loadAspectRatios(
    {required BuildContext context, void Function()? onSelected}) {
  showModalBottomSheet<void>(
      context: context,
      constraints: BoxConstraints(
        maxWidth: 200,
      ),
      builder: (BuildContext context) {
        return ListView(
          children: [
            _buildBtn(context, "16/9", onSelected),
            _buildBtn(context, "4/3", onSelected),
            _buildBtn(context, "1/1", onSelected),
          ],
        );
      });
}

Widget _buildBtn(
    BuildContext context, String ration, void Function()? onSelected) {
  return InkWell(
    onTap: () {
      setAspectRatio(ration);
      if (onSelected != null) {
        onSelected();
      }
      Navigator.pop(context);
    },
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          ration,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    ),
  );
}
