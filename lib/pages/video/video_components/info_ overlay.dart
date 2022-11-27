import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvnet/classes/Channel.dart';
import 'package:tvnet/services/my_globals.dart';

import '../../../components/favorite_button.dart';
import '../../../services/my_functions.dart';

class InfoOverlay extends StatefulWidget {
  Channel currentChannel;
  void Function()? onSelected;
  InfoOverlay({Key? key, required this.currentChannel, this.onSelected})
      : super(key: key);

  @override
  State<InfoOverlay> createState() => _InfoOverlayState();
}

class _InfoOverlayState extends State<InfoOverlay> {
  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Focus(
      canRequestFocus: false,
      onKey: (node, event) {
        if (event.runtimeType.toString() == 'RawKeyDownEvent') {
          if (event.logicalKey == LogicalKeyboardKey.info ||
              event.logicalKey == LogicalKeyboardKey.keyI) {
            Navigator.pop(context);
            return KeyEventResult.handled;
          }
        }

        return KeyEventResult.ignored;
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          isPortrait
              ? SizedBox()
              : Card(
                  child: Container(
                    width: 400,
                    height: 220,
                    child: Column(
                      children: [
                        ListTile(
                          leading: favoriteButton(
                            autoFocus: true,
                            channel: currentChannel,
                            onAdd: () => {
                              addFavorite(currentChannel)
                                  .then((value) => setState(() {})),
                            },
                            onRemove: () => {
                              removeFavorite(currentChannel)
                                  .then((value) => setState(() {})),
                            },
                            isArrowWork: true,
                          ),
                          title: Text(
                            widget.currentChannel.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: SizedBox(
                            width: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: widget.currentChannel.icon,
                                placeholder: (context, url) =>
                                    Icon(Icons.image),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.broken_image),
                                width: 60,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            widget.currentChannel.lcn.toString(),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            epgs.isNotEmpty
                                ? epgs[currentActiveEpgId].title
                                : "",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          Card(
            child: Container(
              width: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Aspect Ratio",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  _buildBtn(context, "16/9", widget.onSelected),
                  _buildBtn(context, "4/3", widget.onSelected),
                  _buildBtn(context, "1/1", widget.onSelected),
                ],
              ),
            ),
          )
        ],
      ),
    );
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
}
