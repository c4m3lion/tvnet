library globals;

import 'dart:convert';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvnet/services/my_functions.dart';

import '../classes/Category.dart';
import '../classes/Channel.dart';
import '../classes/Epg.dart';

List<Channel> channels = List.empty(growable: true);
List<Category> categories = List.empty(growable: true);
List<Channel> categoryChannels = List.empty(growable: true);
List<Epg> epgs = List.empty(growable: true);
Map urls = {};

String name = "";
String token = "";
String macAdress = "";

String aspectRatio = "16/9";

late SharedPreferences localStorage;

late Channel currentChannel;
int currentCategoryId = 0;

int currentActiveEpgId = 0;

int selectedPage = 0;

int currentTempCategoryId = 0;

ItemScrollController itemScrollController = ItemScrollController();

int initialScrollChannel = 0;

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

void setNextCategoryId() {
  if (categories[currentCategoryId].id != "favorites") {
    currentCategoryId++;
  }
  if (currentCategoryId >= categories.length) {
    currentCategoryId = 0;
  }
  setCurrentTempCategoryId(currentCategoryId);
  localStorage.setString("currentCategoryId", categories[currentCategoryId].id);
  categoryChannels = loadByCategoryChannels();
}

void setPreviousCategoryId() {
  if (categories[currentCategoryId].id != "favorites") {
    currentCategoryId--;
  }
  if (currentCategoryId < 0) {
    currentCategoryId = categories.length - 1;
  }
  setCurrentTempCategoryId(currentCategoryId);
  localStorage.setString("currentCategoryId", categories[currentCategoryId].id);
  categoryChannels = loadByCategoryChannels();
}

void setCurrentTempCategoryId(int id) {
  currentTempCategoryId = id;
}

void setAspectRatio(String aspect) {
  aspectRatio = aspect;
  localStorage.setString("aspectRatio", aspect);
}

Channel loadNextChannel() {
  int indx = categoryChannels.indexOf(currentChannel);
  indx++;
  if (indx >= categoryChannels.length) {
    setNextCategoryId();
    indx = 0;
  }
  return categoryChannels.elementAt(indx);
}

Channel loadPreviousChannel() {
  int indx = categoryChannels.indexOf(currentChannel);
  indx--;
  if (indx < 0) {
    setPreviousCategoryId();
    indx = categoryChannels.length - 1;
  }
  return categoryChannels.elementAt(indx);
}

Channel findChannelByLcn(int lcn) {
  return channels.firstWhere((element) => element.lcn == lcn, orElse: () {
    throw ("LCN doesn't exit");
  });
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

  //aspectRatio
  aspectRatio = localStorage.getString("aspectRatio") ?? "16/9";
}
