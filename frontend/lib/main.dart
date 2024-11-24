import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'signin_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

