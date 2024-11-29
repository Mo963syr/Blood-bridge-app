import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'signup_page.dart';
import 'signin_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: WidgetsBinding.instance.window.locale,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', 'AE'),
      ],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      title: 'User Auth App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/signup': (context) => SignupPage(),
        '/': (context) => SigninPage(),
      },
    );
  }
}
