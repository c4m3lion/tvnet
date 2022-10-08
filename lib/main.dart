import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvnet/pages/home/home_page.dart';
import 'package:tvnet/pages/login/login_page.dart';
import 'package:tvnet/pages/setting/setting_page.dart';
import 'package:tvnet/pages/video/video_page.dart';
import 'package:tvnet/services/color_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: MaterialApp(
        title: 'TVNet',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: categoryColor,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage(),
          '/video': (context) => VideoPage(),
        },
      ),
    );
  }
}
