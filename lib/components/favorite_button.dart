import 'package:flutter/material.dart';

import '../classes/Channel.dart';

Widget favoriteButton(
    {required Channel channel,
    required Function onAdd,
    required Function onRemove,
    bool isArrowWork = false,
    bool autoFocus = false}) {
  return InkWell(
    autofocus: autoFocus,
    canRequestFocus: isArrowWork,
    onTap: () => channel.favorite ? onRemove() : onAdd(),
    customBorder: CircleBorder(),
    child: Container(
      padding: EdgeInsets.all(8),
      child: channel.favorite
          ? const Icon(
              Icons.favorite,
              color: Colors.red,
            )
          : const Icon(Icons.favorite_border),
    ),
  );
}
