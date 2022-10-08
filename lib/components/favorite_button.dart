import 'package:flutter/material.dart';

import '../classes/Channel.dart';

Widget favoriteButton(
    {required Channel channel,
    required Function onAdd,
    required Function onRemove}) {
  return GestureDetector(
    onTap: () => channel.favorite ? onRemove() : onAdd(),
    child: Container(
      child: channel.favorite
          ? const Icon(
              Icons.favorite,
              color: Colors.red,
            )
          : const Icon(Icons.favorite_border),
    ),
  );
}
