import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../pages/video/video_page.dart';
import '../services/color_service.dart';

Widget controlPanel(BuildContext context, TabController tabController) {
  return Container(
    width: 60,
    child: Material(
      color: panelColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPage(),
                ),
              ),
            },
            child: Container(
              height: 34,
              width: double.infinity,
              child: Center(
                child: ImageIcon(
                  AssetImage("assets/images/back-icon.png"),
                  size: 60,
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          IconButton(
            splashRadius: 25,
            onPressed: () => {},
            icon: ImageIcon(
              AssetImage("assets/images/channels-icon.png"),
            ),
          ),
          IconButton(
            splashRadius: 25,
            onPressed: () => {},
            icon: ImageIcon(
              AssetImage("assets/images/settings-icon.png"),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: StreamBuilder(
                stream: Stream.periodic(const Duration(minutes: 1)),
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      DateFormat('hh:mm').format(DateTime.now()),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
