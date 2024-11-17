import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'home_page.dart';

void main() {
  runApp(MaterialApp(home: RequestPage()));
}

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedBloodType;
  String? selectedDanger;

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
  XFile? _reportImage;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _reportImage = pickedFile;
    });
  }

  Future<void> bloodRequest(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/blood-request/external'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'location': locationController.text,
        'bloodType': selectedBloodType,
        'phoneNumber': phoneController.text,
        'urgencyLevel': selectedDanger,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 201 ||
        responseData['message'] == 'Blood request created') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('تم إنشاء الطلب بنجاح')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('فشل إنشاء الطلب')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إنشاء طلب حاجة'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: _reportImage != null
                          ? Image.file(
                              File(_reportImage!.path),
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.add_photo_alternate,
                              color: Colors.grey,
                              size: 50,
                            ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'مكان التواجد الحالي ',
                      labelStyle: TextStyle(color: Colors.red[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red[700]!),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.email,
                          color: Colors.red[700]), // أيقونة البريد
                    ),
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: "فصيلة الدم المطلوبة",
                        labelStyle: TextStyle(color: Colors.red[700]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon:
                            const Icon(Icons.bloodtype, color: Colors.red)),
                    value: selectedBloodType,
                    items: bloodTypes.map((bloodType) {
                      return DropdownMenuItem(
                        value: bloodType,
                        child: Text(bloodType),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBloodType = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "رقم الهاتف",
                      labelStyle: TextStyle(color: Colors.red[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.red[700]!),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.lock,
                          color: Colors.red[700]), // أيقونة القفل
                    ),
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: "خطورة الحالة",
                        labelStyle: TextStyle(color: Colors.red[700]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon:
                            const Icon(Icons.warning_amber, color: Colors.red)),
                    value: selectedDanger,
                    items: danger.map((danger) {
                      return DropdownMenuItem(
                        value: danger,
                        child: Text(danger),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDanger = value;
                      });
                    },
                  ),
                  SizedBox(height: 35.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          bloodRequest(context);
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
      ),
    );
  }
}
