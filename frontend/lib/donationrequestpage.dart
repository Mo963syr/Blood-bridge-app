import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonationRequestPage extends StatelessWidget {
  final TextEditingController locationController = TextEditingController();
  String? selectedBloodType;
   String? selectedAvailabilityPeriod;
  final TextEditingController WeightController = TextEditingController();
  File? selectedImage;

Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId'); // استرجاع المعرف
}


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
 final List<String> availabilityOptions = [
    'اليوم',
    'غدًا',
    'في أي وقت خلال أسبوع',
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
  final userId = await getUserId();
  if (userId == null) {
    print('User ID not found');
    return;
  }
  // التحقق من الإدخالات
  if (locationController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('يرجى إدخال مكان التواجد الحالي')),
    );
    return;
  }

  if (selectedBloodType == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('يرجى اختيار فصيلة الدم')),
    );
    return;
  }

  final weight = double.tryParse(WeightController.text);
  if (weight == null || weight <= 50) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('يجب أن يكون وزنك أكبر من 50 كيلو')),
    );
    return;
  }

  if (selectedImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('يرجى اختيار التحليل الطبي')),
    );
    return;
  }

  // إرسال البيانات
  try {
    final dio = Dio();
    final formData = FormData.fromMap({
      'location': locationController.text,
      'bloodType': selectedBloodType,
      'AvailabilityPeriod': selectedAvailabilityPeriod,
      'Weight': WeightController.text,
      'image': await MultipartFile.fromFile(
        selectedImage!.path,
        filename: selectedImage!.path.split('/').last,
      ),
      'userId': userId,
    });

    final response = await dio.post(
      'http://10.0.2.2:8080/api/requests/donation-Request',
      data: formData,
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إنشاء الطلب بنجاح')),
      );
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء إرسال الطلب: ${response.statusCode}')),
      );
    }
  } catch (e) {
    if (e is DioException) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في الاتصال بالخادم: ${e.response?.statusCode}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ غير متوقع')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("انشاء طلب تبرع"),
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
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "تحديد وقت التفرغ",
                labelStyle: TextStyle(color: Colors.red[700]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: selectedAvailabilityPeriod,
              items: availabilityOptions.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (value) {
                selectedAvailabilityPeriod = value;
              },
            ),
                SizedBox(height: 16.0),
                TextField(
                  controller: WeightController,
                  decoration: InputDecoration(
                    labelText: "الوزن",
                    labelStyle: TextStyle(color: Colors.red[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: pickImage,
                  child: Text("اختر التحليل الطبي"),
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
                      child: Text(
                        'الرجوع',
                        style: TextStyle(color: Colors.white),
                      ),
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
