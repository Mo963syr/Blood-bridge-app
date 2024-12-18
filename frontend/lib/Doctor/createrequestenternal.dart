import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'mainDoctorpage.dart';
import '../services/user_preferences.dart';

void main() {
  runApp(createEnternalRwquest());
}

class createEnternalRwquest extends StatefulWidget {
  @override
  State<createEnternalRwquest> createState() => _createEnternalRwquestState();
}

class _createEnternalRwquestState extends State<createEnternalRwquest> {
  final TextEditingController locationController = TextEditingController();
  String? selectedBloodType;
  String? selecteddanger;
  // final TextEditingController phoneController = TextEditingController();

  final List<String> danger = ['low', 'medium', 'high'];
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

  Future<void> bloodRequest(BuildContext context) async {
    String? userId = await UserPreferences.getUserId();
    if (userId == null) {
      print('User ID not found');
      return;
    }
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/requests/blood-request/external'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'location': locationController.text,
        'bloodType': selectedBloodType,
        'urgencyLevel': selecteddanger,
        'userId': userId,
        // 'phoneNumber': phoneController.text,
      }),
    );

    final responseData = jsonDecode(response.body);
    print(response.body);
    print(responseData);
    print(response.statusCode);

    if (response.statusCode == 201 ||
        responseData['message'] == 'Blood request created successfully') {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request created successfully')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DoctorHomePage()),
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
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                      prefixIcon: Icon(Icons.email, color: Colors.red[700]),
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
                      selectedBloodType = value;
                    },
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "خطورة الحالة",
                      labelStyle: TextStyle(color: Colors.red[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
