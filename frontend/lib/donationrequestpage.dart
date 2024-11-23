import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DonationRequestPage extends StatefulWidget {
  @override
  _DonationRequestPageState createState() => _DonationRequestPageState();
}

class _DonationRequestPageState extends State<DonationRequestPage> {
  File? _medicalReportImage;
  TimeOfDay? _selectedTime;
  String? _selectedWeight;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _medicalReportImage = File(pickedFile.path);
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("طلب التبرع"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: "الوزن",
                labelStyle: TextStyle(color: Colors.red[700]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedTime == null
                      ? "لم يتم اختيار وقت"
                      : "وقت التفرغ: ${_selectedTime!.format(context)}",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                ElevatedButton(
                  onPressed: () => pickTime(context),
                  child: Text("اختر وقت التفرغ"),
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('قم بارفاق التحليل الطبي'),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF66BB6A)),
                  onPressed: () {
                    if (_medicalReportImage == null ||
                        _selectedWeight == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("يرجى إكمال جميع الحقول قبل الإرسال")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("تم إرسال الطلب بنجاح!")));
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "إرسال الطلب",
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
                    "إلغاء الطلب",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
