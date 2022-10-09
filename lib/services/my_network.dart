import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> login(
    {required String login,
    required String pass,
    required String macAdress}) async {
  try {
    Response response = await post(
      Uri.parse("https://mw.odtv.az/api/v1/auth"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          "login": login,
          "password": pass,
          "mac": macAdress,
        },
      ),
    );
    Map data = jsonDecode(response.body);
    if (data.containsKey("error")) {
      throw data['error']['message'];
    } else {
      print(response.body);
      return data['sid'];
    }
  } catch (e) {
    throw e.toString();
  }
}

Future<Map> getChannels({required String token}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    Response response = await get(
      Uri.parse("https://mw.odtv.az/api/v1/channels"),
      headers: {
        'oms-client': token,
      },
    );
    Map data = jsonDecode(response.body);
    if (data.containsKey("error")) {
      throw data['error']['message'];
    } else {
      return data;
    }
  } catch (e) {
    throw e.toString();
  }
}

Future<String> getPlayBack(
    {required String channelId, required String token}) async {
  try {
    print("Loading PlayBack");
    Response response = await get(
      Uri.parse("https://mw.odtv.az/api/v1/channel_url/$channelId"),
      headers: {
        'oms-client': token,
      },
    );
    Map data = jsonDecode(response.body);
    if (data.containsKey("error")) {
      throw data['error']['message'];
    } else {
      print(data['url']);
      return data['url'];
    }
  } catch (e) {
    throw e.toString();
  }
}

Future<Map> getEPG({String? channelId, required String token}) async {
  try {
    Response response = await get(
      Uri.parse("https://mw.odtv.az/api/v1/epg/$channelId"),
      headers: {
        'oms-client': token,
      },
    );
    Map data = jsonDecode(response.body);
    if (data.containsKey("error")) {
      throw data['error']['message'];
    } else {
      return data;
    }
  } catch (e) {
    throw e.toString();
  }
}

Future<List<dynamic>> getFavorites({required String token}) async {
  try {
    Response response = await get(
      Uri.parse("https://mw.odtv.az/api/v1/channel_fav"),
      headers: {
        'oms-client': token,
      },
    );
    Map data = jsonDecode(response.body);
    if (data.containsKey("error")) {
      throw data['error']['message'];
    } else {
      return data['fav'];
    }
  } catch (e) {
    throw e.toString();
  }
}

Future<List<dynamic>> addFavorite(
    {required String channelId, required String token}) async {
  try {
    Response response = await post(
      Uri.parse("https://mw.odtv.az/api/v1/channel_fav/add/$channelId"),
      headers: {
        'oms-client': token,
      },
    );
    Map data = jsonDecode(response.body);
    if (data.containsKey("error")) {
      throw data['error']['message'];
    } else {
      return data['fav'];
    }
  } catch (e) {
    throw e.toString();
  }
}

Future<List<dynamic>> removeFavorite(
    {required String channelId, required String token}) async {
  try {
    Response response = await post(
      Uri.parse("https://mw.odtv.az/api/v1/channel_fav/remove/$channelId"),
      headers: {
        'oms-client': token,
      },
    );
    Map data = jsonDecode(response.body);
    if (data.containsKey("error")) {
      throw data['error']['message'];
    } else {
      return data['fav'];
    }
  } catch (e) {
    throw e.toString();
  }
}
