import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_page.dart';
import 'package:intl/intl.dart';
import '../services/user_preferences.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AwarenessCoordinatorPage extends StatefulWidget {
  @override
  _AwarenessCoordinatorPageState createState() =>
      _AwarenessCoordinatorPageState();
}

class _AwarenessCoordinatorPageState extends State<AwarenessCoordinatorPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contectController = TextEditingController();
  Future<void> createpost(BuildContext context) async {
    String? userId = await UserPreferences.getUserId();
    if (userId == null) {
      print('User ID not found');
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/create-post'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': _titleController.text,
        'content': _contectController.text,
        'userId': userId
      }),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 201 ||
        responseData['message'] == 'Blood request created') {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request created successfully')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AwarenessCoordinatorPage()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to create request')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة منشور توعوي'),
        backgroundColor: Colors.red[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // حقل إدخال العنوان
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'أدخل عنوان المنشور',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            SizedBox(height: 16),
            // حقل النص
            TextField(
              controller: _contectController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'اكتب منشور توعوي هنا...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                createpost(context);
              },
              child: Text('إضافة منشور'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400],
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
