import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvnet/services/my_data.dart';
import 'package:tvnet/services/my_network.dart';

class MyFunctions {
  Future<void> loadLocalData() async {
    var localStorage = await SharedPreferences.getInstance();

    String? rawData = localStorage.getString("localData");
    print(rawData);
    MyData.currentChannelId =
        localStorage.getString("currentChannelId") ?? MyData.channels[0].id;
    MyData.currentCategoryId =
        localStorage.getString("currentCategoryId") ?? MyData.categories[0].id;
    if (rawData != null) {
      MyData.playBackUrlMap = jsonDecode(rawData);
    }
  }

  Future<void> saveLocalData() async {
    var localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(
        "localData", jsonEncode(MyData.playBackUrlMap));
  }

  Future<String> getPlayBack({required String channelId}) async {
    if (MyData.playBackUrlMap[channelId] != null) {
      print("YETE" + MyData.playBackUrlMap[channelId]);
      return MyData.playBackUrlMap[channelId];
    }
    MyData.playBackUrlMap[channelId] =
        await MyNetwork().getPlayBack(channelId: channelId);
    saveLocalData();
    return MyData.playBackUrlMap[channelId];
  }
}

class MyMessage {
  static void showSnack({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }
}
