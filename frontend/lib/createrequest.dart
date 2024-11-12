import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart'; // استيراد الصفحة الرئيسية

void main() {
  runApp(RequestPage());
}

class RequestPage extends StatelessWidget {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedBloodType;
  String? selecteddanger;

  final List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  final List<String> danger = ['low', 'medium', 'high'];

  Future<void> bloodRequest(BuildContext context) async {
    final response = await http.post(
      Uri.parse(
          'http://localhost:8080/api/blood-request'), // تأكد من ضبط عنوان الخادم
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'location': locationController.text,
        'bloodType': selectedBloodType,
        'phoneNumber': phoneController.text,
        'urgencyLevel': selecteddanger,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 201 ||
        responseData['message'] == 'Blood request created') {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request created successfully')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
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
        title: Text('إنشاء طلب حاجة'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.red,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                      hintText: "مكان التواجد الحالي",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(Icons.home)),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      hintText: "فصيلة الدم المطلوبة",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(Icons.bloodtype)),
                  value: selectedBloodType,
                  items: bloodTypes.map((bloodType) {
                    return DropdownMenuItem(
                      value: bloodType,
                      child: Text(bloodType),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedBloodType = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                      hintText: "رقم الهاتف",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(Icons.phone)),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      hintText: "خطورة الحالة",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(Icons.search)),
                  value: selecteddanger,
                  items: danger.map((danger) {
                    return DropdownMenuItem(
                      value: danger,
                      child: Text(danger),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selecteddanger = value;
                  },
                ),
                SizedBox(height: 35.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        bloodRequest(context); // استدعاء دالة الطلب
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF66BB6A)),
                      child: Text(
                        'إرسال الطلب',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('الرجوع'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
