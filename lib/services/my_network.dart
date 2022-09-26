import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mac_address/mac_address.dart';
import 'package:tvnet/services/my_data.dart';

import 'my_functions.dart';

class MyNetwork {
  Future<String> login({required String login, required String pass}) async {
    try {
      MyData.macAdress = await readFile();
      print("macADress: " + MyData.macAdress);
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
      MyPrint.printWarning(response.body);
      Map data = jsonDecode(response.body);
      if (data.containsKey("error")) {
        return data['error']['message'];
      } else {
        MyData.token = data['sid'];
        return "OK";
      }
    } catch (e) {
      MyPrint.printError(e.toString());
      return e.toString();
    }
  }

  Future<String> readFile() async {
    String text = '02:00:00:00:00:00';
    try {
      final File file = File('/sys/class/net/eth0/address');
      text = await file.readAsString();
    } catch (e) {
      print("I am Here");
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
