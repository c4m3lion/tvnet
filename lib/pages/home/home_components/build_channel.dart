import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tvnet/components/favorite_button.dart';
import 'package:tvnet/services/my_functions.dart';
import 'package:tvnet/services/my_globals.dart';

import '../../../classes/Channel.dart';
import '../../video/video_page.dart';

Widget buildChannels({
  required final Function() refreshPage,
  required List<Channel> channels,
  final Function(Channel channel)? selectChannel,
}) {
  return ScrollablePositionedList.builder(
    shrinkWrap: true,
    itemCount: channels.length,
    itemScrollController: itemScrollController,
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
          autofocus: channels[index].id == currentChannel.id,
          onTap: () {
            setCurrentCategoryId(currentTempCategoryId);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPage(channel: channels[index]),
              ),
            );
          },
          child: ListTile(
            selected: channels[index].id == currentChannel.id,
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
