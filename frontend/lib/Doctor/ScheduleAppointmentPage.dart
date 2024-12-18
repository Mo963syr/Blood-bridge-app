import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScheduleAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> needy;

  ScheduleAppointmentPage({Key? key, required this.needy}) : super(key: key);

  @override
  _ScheduleAppointmentPageState createState() =>
      _ScheduleAppointmentPageState();
}

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _sendAppointmentToServer() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى تحديد التاريخ والوقت')),
      );
      return;
    }

    // تحويل التاريخ والوقت إلى صيغة مناسبة
    final DateTime appointmentDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    // بيانات الطلب
    final Map<String, dynamic> requestBody = {
      'needyId': widget.needy['user'].toString(),
      'appointmentDateTime': appointmentDateTime.toIso8601String().toString(),
      // أضف الحقول الأخرى التي تحتاجها هنا مع تحويلها إلى نصوص
    };

    print(requestBody);
    // إرسال الطلب
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/appointments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );
      print(requestBody);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تحديد الموعد بنجاح')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('فشل في تحد الموعد: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تحديد موعد'),
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'تفاصيل الحالة:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'الموقع: ${widget.needy['location'] ?? 'غير متاح'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'فصيلة الدم: ${widget.needy['bloodType'] ?? 'غير متاح'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'مستوى الخطورة: ${widget.needy['urgencyLevel'] ?? 'غير متاح'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'حدد تاريخ ووقت الموعد:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'التاريخ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              controller: TextEditingController(
                text: _selectedDate == null
                    ? ''
                    : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'الوقت',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              readOnly: true,
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _selectedTime = pickedTime;
                  });
                }
              },
              controller: TextEditingController(
                text: _selectedTime == null
                    ? ''
                    : '${_selectedTime!.hour}:${_selectedTime!.minute}',
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: _sendAppointmentToServer,
                icon: Icon(Icons.check),
                label: Text('تأكيد الموعد'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
