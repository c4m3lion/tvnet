import 'package:flutter/material.dart';

Widget numberOverlay(int id) {
  if (id == 0) {
    return Container();
  }
  return Card(
    child: Padding(
      padding: EdgeInsets.all(8),
      child: Text(id.toString()),
    ),
  );
}
