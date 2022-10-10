import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tvnet/pages/home/home_page.dart';
import 'package:tvnet/pages/login/login_page.dart';
import 'package:tvnet/pages/video/video_page.dart';
import 'package:tvnet/services/color_service.dart';
import 'package:tvnet/translations/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('az'),
        Locale('uk'),
        Locale('ar'),
        Locale('ru'),
      ],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('az'),
      assetLoader: const CodegenLoader(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        SingleActivator(LogicalKeyboardKey.select): const ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.keyH): const ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.enter): const ActivateIntent(),
      },
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'TVNet',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: categoryColor,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
            ),
          ),
          useMaterial3: true,
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
