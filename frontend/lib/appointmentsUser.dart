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
          }).map<Map<String, String>>((item) {
            String appointmentType = item['donorId'] == userId.toString()
                ? 'موعد تبرع'
                : 'موعد الحصول على الدم';

            return {
              'id': item['_id'] ?? '',
              'donorReqId': item['donorReqId'] ?? '',
              'needyReqId': item['needyReqId'] ?? '',
              'donorId': item['donorId'] ?? '',
              'donorname': item['donorname'] ?? 'غير معروف',
              'needyId': item['needyId'] ?? '',
              'needyname': item['needyname'] ?? 'غير معروف',
              'appointmentDateTime':
                  item['appointmentDateTime'].toString() ?? 'غير محدد',
              'notes': item['notes'] ?? '',
              'appointmentType': appointmentType,
              'status': item['status'] ?? 'pending', // حالة الموعد
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

  Future<void> deleteAppointment(String appointmentId) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'http://10.0.2.2:8080/api/delete-appointments/$appointmentId'),
      );

      if (response.statusCode == 200) {
        setState(() {
          appointments.removeWhere((appt) => appt['id'] == appointmentId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إلغاء الموعد بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في إلغاء الموعد: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error deleting appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء محاولة الإلغاء'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> UpdateStatus(String appointmentId, String newStatus) async {
    try {
      final Map<String, String> requestBody = {
        'status': newStatus,
      };

      final response = await http.put(
        Uri.parse(
            'http://10.0.2.2:8080/api/update-appointments-status/$appointmentId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        setState(() {
          final appointment =
              appointments.firstWhere((appt) => appt['id'] == appointmentId);
          appointment['status'] = newStatus; // تحديث الحالة
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تحديث الحالة بانتظارك'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في تحديث الحالة: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error updating status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء محاولة تحديث الحالة'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> UpdaterequestStatus(
      String donationRequestId, String newStatus, String needRequestId) async {
    try {
      final Map<String, String> requestBody = {
        'requestStatus': newStatus,
        'donationRequestId': donationRequestId,
        'needRequestId': needRequestId
      };

      final response = await http.put(
        Uri.parse('http://10.0.2.2:8080/api/requests/update-status-requests'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // setState(() {
        //   final appointment =
        //       appointments.firstWhere((appt) => appt['id'] == appointmentId);
        //   appointment['status'] = newStatus; // تحديث الحالة
        // });

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('تم تحديث الحالة بانتظارك'),
        //     backgroundColor: Colors.green,
        //   ),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في تحديث الحالة: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error updating status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء محاولة تحديث الحالة'),
          backgroundColor: Colors.red,
        ),
      );
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
          : appointments.length == 0
              ? Center(
                  child: Text(
                  'لايوجد مواعيد محددة ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ))
              : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
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
                            const SizedBox(height: 8),
                            // عرض حالة الموعد مع الأيقونة المناسبة
                            Row(
                              children: [
                                Text('حالة الموعد: '),
                                if (appointment['status'] == 'completed')
                                  Icon(Icons.assignment_turned_in_outlined,
                                      color: Colors.green),
                                if (appointment['status'] == 'pending')
                                  Icon(Icons.access_time, color: Colors.orange),
                                if (appointment['status'] == 'assigned')
                                  Icon(Icons.assignment,
                                      color: const Color.fromARGB(
                                          255, 3, 158, 169)),
                                const SizedBox(width: 8),
                                Text(
                                  appointment['status'] == 'completed'
                                      ? 'مكتمل'
                                      : appointment['status'] == 'pending'
                                          ? 'بانتظار التأكيد '
                                          : 'المحتاج بانتظارك عزيزي',
                                  style: TextStyle(
                                    color: appointment['status'] == 'completed'
                                        ? Colors.green
                                        : appointment['status'] == 'pending'
                                            ? Colors.orange
                                            : const Color.fromARGB(
                                                255, 3, 158, 169),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            appointment['status'] == 'completed'
                                ? const SizedBox(height: 16)
                                : appointment['status'] == 'pending'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              if (appointment['id']!
                                                  .isNotEmpty) {
                                                deleteAppointment(
                                                    appointment['id']!);
                                                UpdaterequestStatus(
                                                    appointment['donorReqId']!,
                                                    'approved',
                                                    appointment['needyReqId']!);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'لا يوجد معرف للموعد'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: const Text('إلغاء الموعد'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              UpdateStatus(appointment['id']!,
                                                  'assigned');
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                            ),
                                            child: const Text('تأكيد الحضور'),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              if (appointment['id']!
                                                  .isNotEmpty) {
                                                deleteAppointment(
                                                    appointment['id']!);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'لا يوجد معرف للموعد'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: const Text('إلغاء الموعد'),
                                          ),
                                        ],
                                      )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
