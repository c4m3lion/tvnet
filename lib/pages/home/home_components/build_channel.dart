import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvnet/components/favorite_button.dart';
import 'package:tvnet/pages/video/vlc_player_page.dart';
import 'package:tvnet/services/my_functions.dart';

import '../../../classes/Channel.dart';

Widget buildChannels(
    {required final Function() refreshPage,
    required List<Channel> channels,
    final Function(Channel channel)? selectChannel}) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: channels.length,
    itemBuilder: (context, index) {
      return Focus(
        canRequestFocus: false,
        onFocusChange: (focused) {
          if (focused && selectChannel != null) {
            selectChannel(channels[index]);
          }
        },
        onKey: (node, event) {
          if (index >= channels.length - 1 &&
              event.logicalKey == LogicalKeyboardKey.arrowDown) {
            return KeyEventResult.handled;
          }
          if (index <= 0 && event.logicalKey == LogicalKeyboardKey.arrowUp) {
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VlcPlayerPage(channel: channels[index]),
              ),
            );
          },
          child: ListTile(
            leading: SizedBox(
              width: 60,
              child: CachedNetworkImage(
                imageUrl: channels[index].icon,
                placeholder: (context, url) => Icon(Icons.image),
                errorWidget: (context, url, error) => Icon(Icons.broken_image),
              ),
            ),
            title: Text(channels[index].name),
            trailing: favoriteButton(
              channel: channels[index],
              onAdd: () => {
                addFavorite(channels[index]).then((value) => refreshPage()),
              },
              onRemove: () => {
                removeFavorite(channels[index]).then((value) => refreshPage()),
              },
            ),
          ),
        ),
      );
    },
  );
}
