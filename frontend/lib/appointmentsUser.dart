import 'package:flutter/material.dart';

class AppointmentsPage extends StatelessWidget {
  final List<Map<String, String>> appointments = [
    {
      'location': 'الرياض',
      'bloodType': 'O+',
      'appointmentDate': '2024-12-31',
      'appointmentTime': '10:00 AM',
      'urgencyLevel': 'عالي',
      'userType': 'محتاج',
    },
    {
      'location': 'جدة',
      'bloodType': 'A-',
      'appointmentDate': '2024-12-30',
      'appointmentTime': '02:00 PM',
      'urgencyLevel': 'متوسط',
      'userType': 'متبرع',
    },
    {
      'location': 'الدمام',
      'bloodType': 'B+',
      'appointmentDate': '2024-12-29',
      'appointmentTime': '04:00 PM',
      'urgencyLevel': 'منخفض',
      'userType': 'محتاج',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المواعيد المحددة'),
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 5,
            child: ListTile(
              title: Text('الموقع: ${appointment['location']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('فصيلة الدم: ${appointment['bloodType']}'),
                  Text('تاريخ الموعد: ${appointment['appointmentDate']}'),
                  Text('الوقت: ${appointment['appointmentTime']}'),
                  Text('مستوى الخطورة: ${appointment['urgencyLevel']}'),
                  Text('نوع المستخدم: ${appointment['userType']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
