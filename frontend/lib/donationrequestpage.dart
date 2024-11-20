import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DonationRequestPage extends StatefulWidget {
  @override
  _DonationRequestPageState createState() => _DonationRequestPageState();
}

class _DonationRequestPageState extends State<DonationRequestPage> {
  XFile? _medicalReportImage;
  String? _selectedWeight;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _medicalReportImage = pickedFile;
    });
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "رفع صورة التحليل الطبي",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
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
                child: _medicalReportImage != null
                    ? Image.file(
                        File(_medicalReportImage!.path),
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.add_photo_alternate,
                        color: Colors.grey,
                        size: 50,
                      ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "تحديد الوزن (كغ)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedWeight,
              hint: Text("اختر الوزن"),
              items: ["50", "55", "60", "65", "70", "75", "80"]
                  .map((weight) => DropdownMenuItem(
                        value: weight,
                        child: Text("$weight كغ"),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedWeight = value;
                });
              },
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
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
                  child: Text("إرسال الطلب"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text("إلغاء الطلب"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
