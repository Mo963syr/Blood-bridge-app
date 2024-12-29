import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonationRequestPage extends StatefulWidget {
  @override
  _DonationRequestPageState createState() => _DonationRequestPageState();
}

class _DonationRequestPageState extends State<DonationRequestPage> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String? selectedBloodType;
  DateTime? selectedDateTime;
  File? selectedImage;

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> bloodRequest(BuildContext context) async {
    final userId = await getUserId();
    if (userId == null) {
      print('User ID not found');
      return;
    }

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

    final weight = double.tryParse(weightController.text);
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

    if (selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى اختيار تاريخ ووقت التفرغ')),
      );
      return;
    }

    try {
      final dio = Dio();
      final formData = FormData.fromMap({
        'location': locationController.text,
        'bloodType': selectedBloodType,
        'AvailabilityPeriod': selectedDateTime?.toIso8601String(),
        'Weight': weightController.text,
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
          SnackBar(
              content:
                  Text('حدث خطأ أثناء إرسال الطلب: ${response.statusCode}')),
        );
      }
    } catch (e) {
      if (e is DioException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('خطأ في الاتصال بالخادم: ${e.response?.statusCode}')),
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
        title: Text("إنشاء طلب تبرع"),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'مكان التواجد الحالي',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "فصيلة الدم",
                  border: OutlineInputBorder(),
                ),
                value: selectedBloodType,
                items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                    .map((bloodType) => DropdownMenuItem(
                          value: bloodType,
                          child: Text(bloodType),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBloodType = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => pickDateTime(context),
                child: Text(selectedDateTime == null
                    ? "اختيار تاريخ ووقت التفرغ"
                    : "${selectedDateTime!.year}-${selectedDateTime!.month}-${selectedDateTime!.day} ${selectedDateTime!.hour}:${selectedDateTime!.minute}"),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: "الوزن",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: pickImage,
                child: Text("اختر التحليل الطبي"),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => bloodRequest(context),
                child: Text("إرسال الطلب"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
