import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/user_preferences.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<Map<String, String>> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      String? userId = await UserPreferences.getUserId();
      print(userId);
      if (userId == null) {
        print('User ID not found');
        setState(() {
          isLoading = false;
        });
        return;
      }

      final response = await http
          .get(Uri.parse('http://10.0.2.2:8080/api/View-appointments'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          appointments = data.where((item) {
            return item['donorId'] == userId.toString();
            // تصفية المواعيد بناءً على معرّف المتبرع فقط
          }).map<Map<String, String>>((item) {
            // إنشاء متغير appointmentType
            String appointmentType = item['donorId'] == userId.toString()
                ? 'موعد تبرع'
                : 'موعد الحصول على الدم';

            return {
              'id': item['_id'] ?? '',
              'donorId': item['donorId'] ?? '',
              'donorname': item['donorname'] ?? 'غير معروف',
              'needyId': item['needyId'] ?? '',
              'needyname': item['needyname'] ?? 'غير معروف',
              'appointmentDateTime':
                  item['appointmentDateTime'].toString() ?? 'غير محدد',
              'notes': item['notes'] ?? '',
              'appointmentType': appointmentType, // إضافة نوع الموعد
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المواعيد المحددة'),
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'نوع الموعد: ${appointment['appointmentType']} ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('اسم المتبرع: ${appointment['donorname']}'),
                        Text('اسم المحتاج: ${appointment['needyname']}'),
                        Text(
                            'تاريخ الموعد: ${appointment['appointmentDateTime']}'),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                print(
                                    'إلغاء الموعد ${appointment['appointmentDateTime']}');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('إلغاء الموعد'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print(
                                    'تأكيد الحضور للموعد ${appointment['appointmentDate']}');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('تأكيد الحضور'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
