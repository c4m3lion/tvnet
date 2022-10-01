import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mac_address/mac_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tvnet/services/my_data.dart';

class MyNetwork {
  Future<String> login({required String login, required String pass}) async {
    try {
      MyData.macAdress = await readMacAdress();
      //print("macADress: " + MyData.macAdress);
      Response response = await post(
        Uri.parse("https://mw.odtv.az/api/v1/auth"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            "login": login,
            "password": pass,
            "mac": MyData.macAdress,
          },
        ),
      );
      //MyPrint.printWarning(response.body);
      Map data = jsonDecode(response.body);
      if (data.containsKey("error")) {
        return data['error']['message'];
      } else {
        MyData.token = data['sid'];
        return "OK";
      }
    } catch (e) {
      //MyPrint.printError(e.toString());
      return e.toString();
    }
  }

  Future<String> getChannels() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Response response = await get(
        Uri.parse("https://mw.odtv.az/api/v1/channels"),
        headers: {
          'oms-client': MyData.token,
        },
      );
      //MyPrint.printWarning(response.body);
      Map data = jsonDecode(response.body);

      if (data.containsKey("error")) {
        return data['error']['message'];
      } else {
        prefs.setString("AllChannels", response.body);
        MyData.categories.clear();
        MyData.channels.clear();
        MyData.categories = List<Category>.from(
            data["categories"].map((x) => Category.fromJson(x)));
        MyData.channels = List<Channel>.from(
            data["channels"].map((x) => Channel.fromJson(x)));
        return "OK";
      }
    } catch (e) {
      //MyPrint.printError(e.toString());
      return e.toString();
    }
  }

  Future<String?> getPlayBack({required String channelId}) async {
    try {
      Response response = await get(
        Uri.parse("https://mw.odtv.az/api/v1/channel_url/$channelId"),
        headers: {
          'oms-client': MyData.token,
        },
      );
      Map data = jsonDecode(response.body);
      if (data.containsKey("error")) {
        return null;
      } else {
        return data['url'];
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
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
      print("Couldn't read file");
      text = '02:00:00:00:00:00';
    }
    if (text == "") {
      text = '02:00:00:00:00:00';
    }
    return text;
  }
}
