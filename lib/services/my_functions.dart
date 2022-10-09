import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mac_address/mac_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvnet/classes/Channel.dart';

import '../classes/Category.dart';
import '../classes/Epg.dart';
import '../services/my_globals.dart' as globals;
import '../services/my_network.dart' as my_network;

Future<String> login({required String login, required String password}) async {
  var macAdress = await readMacAdress();
  return await my_network.login(
      login: login, pass: password, macAdress: macAdress);
}

Future<void> setChannelsAndCategories() async {
  Map data = await my_network.getChannels(token: globals.token);
  globals.categories =
      List<Category>.from(data["categories"].map((x) => Category.fromJson(x)));
  globals.channels =
      List<Channel>.from(data["channels"].map((x) => Channel.fromJson(x)));
  globals.categories.insert(
      0, new Category(id: "favorites", name: "Favorites", position: -1));
  globals.categories.insert(
      0, new Category(id: "allChannel", name: "All Channels", position: -2));
  await getFavorites();
  globals.loadCurrents();
  print("IA msdasd");

  //TODO:add localstoarage
}

Future<void> getFavorites() async {
  print("Loading Favorites!");
  List data = await my_network.getFavorites(token: globals.token);

  globals.channels.forEach((element) {
    element.favorite = data.any((value) => value == element.id);
  });
}

Future<void> addFavorite(Channel? channel) async {
  channel ??= globals.currentChannel;
  List data =
      await my_network.addFavorite(token: globals.token, channelId: channel.id);

  globals.channels.forEach((element) {
    element.favorite = data.any((value) => value == element.id);
  });
}

Future<void> removeFavorite(Channel channel) async {
  print("removefac" + channel.name);
  List data = await my_network.removeFavorite(
      token: globals.token, channelId: channel.id);

  globals.channels.forEach((element) {
    element.favorite = data.any((value) => value == element.id);
  });
}

Future<void> loadEpgs(Channel channel) async {
  Map data =
      await my_network.getEPG(token: globals.token, channelId: channel.id);
  var seen = Set<String>();

  globals.epgs = List<Epg>.from(data["epg"].map((x) => Epg.fromJson(x)))
      .where((epg) => seen.add(epg.start.toString()))
      .toList();
}

Future<String> loadUrl(Channel channel) async {
  if (globals.urls[channel.id] == null) {
    print("Loading form internet");
    globals.urls[channel.id] = await my_network.getPlayBack(
        channelId: channel.id, token: globals.token);
    await globals.localStorage.setString("URLS", jsonEncode(globals.urls));
  }
  return globals.urls[channel.id];
}

List<Channel> loadByCategoryChannels({String? categoryId}) {
  categoryId ??= globals.categories[globals.currentCategoryId].id;
  switch (categoryId) {
    case "allChannel":
      return globals.channels;
    case "favorites":
      return globals.channels.where(((element) => element.favorite)).toList();
  }
  return globals.channels
      .where(((element) => element.category?.id == categoryId))
      .toList();
}

showSnack(context, String text) {
  return ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
}

clearSnackBar(context) {
  return ScaffoldMessenger.of(context).removeCurrentSnackBar();
}

Future<String> readMacAdress() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String text = prefs.getString("macAdress") ?? "";
  if (text != "") return text;
  try {
    final File file = File('/sys/class/net/eth0/address');
    text = await file.readAsString();
  } catch (e) {
    text = await GetMac.macAddress;
  } catch (e) {
    text = '02:00:00:00:00:00';
  }
  if (text == "") {
    return '02:00:00:00:00:00';
  }
  return text;
}
