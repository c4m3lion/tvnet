import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tvnet/classes/Channel.dart';

import '../services/my_functions.dart';
import '../services/my_globals.dart' as globals;

class BuildEpg extends StatefulWidget {
  Channel channel;
  BuildEpg({Key? key, required this.channel}) : super(key: key);

  @override
  State<BuildEpg> createState() => _BuildEpgState();
}

class _BuildEpgState extends State<BuildEpg> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  int getCurrentEpgScrollPosition() {
    for (int i = 0; i < globals.epgs.length; i++) {
      bool temp = DateTime.now().isAfter(
              DateTime.fromMillisecondsSinceEpoch(globals.epgs[i].start)) &&
          DateTime.now().isBefore(
              DateTime.fromMillisecondsSinceEpoch(globals.epgs[i].end));

      if (temp) {
        globals.currentActiveEpgId = i;
        if (i > 0) {
          return i - 1;
        }
        return i;
      }
    }
    globals.currentActiveEpgId = 0;
    return globals.currentActiveEpgId;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loadEpgs(widget.channel),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading....');
          default:
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Icon(Icons.error);
            } else {
              return ScrollablePositionedList.builder(
                itemCount: globals.epgs.length,
                initialScrollIndex: getCurrentEpgScrollPosition(),
                itemBuilder: (context, index) => Card(
                  color:
                      index == globals.currentActiveEpgId ? Colors.blue : null,
                  child: ListTile(
                    title: Text(globals.epgs[index].title),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                globals.epgs[index].start),
                          ),
                        ),
                        Text(
                          DateFormat('HH:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                globals.epgs[index].end),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
              );
            }
        }
      },
    );
  }
}
