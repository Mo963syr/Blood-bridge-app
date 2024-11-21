import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'home_page.dart';

void main() {
  runApp(RequestPage());
}

class RequestPage extends StatelessWidget {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedBloodType;
  String? selecteddanger;
  File? selectedImage;

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

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
    }
  }

  Future<void> bloodRequest(BuildContext context) async {
    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an image')));
      return;
    }
if (locationController.text.isEmpty ||
    selectedBloodType == null ||
    phoneController.text.isEmpty ||
    selecteddanger == null ||
    selectedImage == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('يرجى ملء جميع الحقول واختيار صورة')),
  );
  return;
}
    try {
  final dio = Dio();
  final formData = FormData.fromMap({
    'location': locationController.text,
    'bloodType': selectedBloodType,
    'phoneNumber': phoneController.text,
    'urgencyLevel': selecteddanger,
    'image': await MultipartFile.fromFile(
      selectedImage!.path,
      filename: selectedImage!.path.split('/').last,
    ),
    'userId':'673cdc35fe8411b2947e6cc7',
  });

  final response = await dio.post(
    'http://10.0.2.2:8080/api/requests/blood-request/external',
    data: formData,
  );




  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request created successfully')),
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
        title: Text('إنشاء طلب حاجة'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'مكان التواجد الحالي',
                    labelStyle: TextStyle(color: Colors.red[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                  ),
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
                    labelText: "رقم الهاتف",
                    labelStyle: TextStyle(color: Colors.red[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: pickImage,
                  child: Text('اختر تقريرًا طبيًا'),
                ),
                SizedBox(height: 16.0),
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
    );
  }
}
