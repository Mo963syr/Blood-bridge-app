import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/user_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int donations = 0;
  int points = 0;
  bool certificate = false;
  String firstname = 'لا توجد بيانات';
  String lastname = 'لا توجد بيانات';
  String num = '000';

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      String? userId = await UserPreferences.getUserId();
      if (userId == null) {
        _showError('لم يتم العثور على معرف المستخدم.');
        return;
      }

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/donation-count'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        setState(() {
          firstname = responseData['user']['firstName'] ?? 'لا توجد بيانات';
          lastname = responseData['user']['lastName'] ?? 'لا توجد بيانات';
          donations = responseData['donations'] ?? 0;
          points = responseData['points'] ?? 0;
          certificate = responseData['certificate'] ?? false;
          num = responseData['user']['number']?.toString() ?? '000';
        });
      } else {
        _showError('حدث خطأ أثناء جلب البيانات: ${response.body}');
      }
    } catch (e) {
      _showError('حدث خطأ: $e');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('خطأ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('حسنًا'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الملف الشخصي'),
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.red[400],
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('التبرعات', '$donations'),
                  _buildStatItem('النقاط', '$points'),
                  _buildStatItem('الشهادة', certificate ? 'نعم' : 'لا'),
                ],
              ),
              SizedBox(height: 20),
              Divider(thickness: 1, color: Colors.grey[300]),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('الاسم:', '$firstname $lastname'),
                    SizedBox(height: 15),
                    _buildEditableInfoRow(
                      label: 'رقم الهاتف:',
                      value: num,
                      onEdit: () {
                        _showEditDialog(context, 'رقم الهاتف', num);
                      },
                    ),
                    SizedBox(height: 15),
                    _buildEditableInfoRow(
                      label: 'كلمة المرور:',
                      value: '********',
                      onEdit: () {
                        _showEditDialog(context, 'كلمة المرور', '********');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildEditableInfoRow({
    required String label,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: onEdit,
        ),
      ],
    );
  }

  void _showEditDialog(
      BuildContext context, String field, String currentValue) {
    final TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تعديل $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'أدخل $field الجديد'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              print('تم تحديث $field: ${controller.text}');
              Navigator.pop(context);
            },
            child: Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
