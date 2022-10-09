library globals;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvnet/services/my_functions.dart';

import '../classes/Category.dart';
import '../classes/Channel.dart';
import '../classes/Epg.dart';

List<Channel> channels = List.empty(growable: true);
List<Category> categories = List.empty(growable: true);
List<Epg> epgs = List.empty(growable: true);
Map urls = {};

String name = "";
String token = "";
String macAdress = "";

late SharedPreferences localStorage;

late Channel currentChannel;
int currentCategoryId = 0;

int currentActiveEpgId = 0;

int selectedPage = 0;

void setCurrentChannelId(Channel id) {
  epgs.clear();
  loadEpgs(id);
  currentChannel = id;
  localStorage.setString("currentChannelId", id.id);
}

void setCurrentCategoryId(int id) {
  currentCategoryId = id;
  localStorage.setString("currentCategoryId", categories[id].id);
}

Category get getCurrentCategory {
  return categories[currentCategoryId];
}

void loadCurrents() {
  //channel
  var tempId = localStorage.getString("currentChannelId") ?? channels.first.id;
  currentChannel = channels.firstWhere((element) => element.id == tempId);

  //category
  tempId = localStorage.getString("currentCategoryId") ?? categories.first.id;
  currentCategoryId = categories.indexWhere((element) => element.id == tempId);

  //urls
  urls = jsonDecode(localStorage.getString("URLS") ?? "{}");
}
