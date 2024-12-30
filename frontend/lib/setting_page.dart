import 'package:flutter/material.dart';
import 'package:frontend/signin_page.dart'; // استيراد صفحة تسجيل الدخول
import 'package:provider/provider.dart'; // استيراد Provider
import 'package:frontend/main.dart';

import 'home_page.dart'; // استيراد ملف الـ Main لتحميل ThemeProvider

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotificationsEnabled = false;
  bool _isDarkMode = false;

  // تفعيل أو إيقاف الوضع الداكن
  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });

    // الوصول إلى ThemeProvider من خلال الـ context وتغيير الوضع
    if (_isDarkMode) {
      Provider.of<ThemeProvider>(context, listen: false).setDarkMode();
    } else {
      Provider.of<ThemeProvider>(context, listen: false).setLightMode();
    }
  }

  // تفعيل أو إلغاء تفعيل الإشعارات
  void _toggleNotifications(bool value) {
    setState(() {
      _isNotificationsEnabled = value;
    });
  }

  // تسجيل الخروج
  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('هل تريد تسجيل الخروج؟'),
          content: Text('سيتم تسجيل الخروج من الحساب الحالي.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('لا'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SigninPage()),
                );
              },
              child: Text('نعم'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإعدادات'),
        backgroundColor: Colors.red[400],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('تفعيل الإشعارات'),
            trailing: Switch(
              value: _isNotificationsEnabled,
              onChanged: _toggleNotifications,
            ),
          ),
          ListTile(
            title: Text('الوضع الداكن'),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
            ),
          ),
          ListTile(
            title: Text('سجل الطلبات'),
            onTap: () {
              // الانتقال إلى صفحة سجل الطلبات
            },
          ),
          ListTile(
            title: Text('تسجيل الخروج'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
