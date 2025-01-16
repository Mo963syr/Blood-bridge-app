import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_page.dart';
import 'package:intl/intl.dart';

class AwarenessCoordinatorPage extends StatefulWidget {
  @override
  _AwarenessCoordinatorPageState createState() =>
      _AwarenessCoordinatorPageState();
}

class _AwarenessCoordinatorPageState extends State<AwarenessCoordinatorPage> {
  TextEditingController _titleController =
      TextEditingController(); // للتحكم في العنوان
  TextEditingController _controller = TextEditingController(); // للتحكم في النص

  void _addPost() {
    if (_controller.text.isNotEmpty && _titleController.text.isNotEmpty) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);

      // إضافة المنشور مع العنوان
      Provider.of<ThemeProvider>(context, listen: false).addPost({
        'title': _titleController.text, // أخذ العنوان من TextField
        'text': _controller.text,
        'timestamp': now, // حفظ الوقت عند النشر
      });

      _titleController.clear(); // مسح حقل العنوان بعد الإضافة
      _controller.clear(); // مسح حقل النص بعد الإضافة
      Navigator.pop(context); // العودة إلى الصفحة السابقة بعد الإضافة
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
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'اكتب منشور توعوي هنا...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            SizedBox(height: 16),
            // زر لنشر المنشور
            ElevatedButton(
              onPressed: _addPost,
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
