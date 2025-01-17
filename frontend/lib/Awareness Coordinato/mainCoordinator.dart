import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_page.dart';
import 'package:intl/intl.dart';
import '../services/user_preferences.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class AwarenessCoordinatorPage extends StatefulWidget {
  @override
  _AwarenessCoordinatorPageState createState() =>
      _AwarenessCoordinatorPageState();
}

class _AwarenessCoordinatorPageState extends State<AwarenessCoordinatorPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contectController = TextEditingController();

  TextEditingController _controller = TextEditingController();
  Future<void> createpost(BuildContext context) async {
    String? userId = await UserPreferences.getUserId();
    if (userId == null) {
      print('User ID not found');
      return;
    }
    if (_titleController == null || _contectController == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("يرجى ملئ جميع الحقول")));
      return;
    }
    try {
      final dio = Dio();
      final formData = FormData.fromMap({
        'title': _titleController,
        'content': _contectController,
        'userId': userId,
      });

      final response = await dio.post(
        'http://10.0.2.2:8080/api/create-post',
        data: formData,
      );
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AwarenessCoordinatorPage()),
        );
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${response.data}');
      }
    } catch (e) {
      if (e is DioException) {
        print('DioError: ${e.response?.statusCode}');
        print('Error data: ${e.response?.data}');
      } else {
        print('Unexpected error: $e');
      }
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
