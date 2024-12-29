import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AppointmentsPage extends StatelessWidget {
  Future<List<Map<String, String>>> fetchAppointments() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:8080/api/View-appointments'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map<Map<String, String>>((item) {
          return {
            "id": item["_id"] ?? '', // تأكد من أن حقل 'id' موجود
            "donorname": item["donorname"] ?? '',
            "needyname": item["needyname"] ?? '',
            "appointmentDateTime": item["appointmentDateTime"] ?? '',
            "note": item["notes"] ?? '',
          };
        }).toList();
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<void> updateAppointmentNotes(
      BuildContext context, String appointmentId, String notes) async {
    final String apiUrl =
        'http://10.0.2.2:8080/api/appointments-notes/$appointmentId';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'notes': notes}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تحديث الملاحظات بنجاح')),
        );
        Navigator.pop(context); // الرجوع إلى الشاشة السابقة
      } else {
        throw Exception('Failed to update notes: ${response.body}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء تحديث الملاحظات: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المواعيد'),
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: fetchAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'حدث خطأ أثناء تحميل البيانات.',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'لا توجد مواعيد حالياً.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final appointments = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentDetailsPage(
                          appointment: appointment,
                          updateAppointmentNotes: updateAppointmentNotes,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "اسم المتبرع: ${appointment['donorname']}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[400],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "اسم المحتاج: ${appointment['needyname']}",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "تاريخ الموعد: ${appointment['appointmentDateTime']}",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class AppointmentDetailsPage extends StatelessWidget {
  final Map<String, String> appointment;
  final TextEditingController _notesController = TextEditingController();
  final Function(BuildContext, String, String) updateAppointmentNotes;

  AppointmentDetailsPage({
    required this.appointment,
    required this.updateAppointmentNotes,
  }) {
    _notesController.text =
        appointment['notes'] ?? ''; // تحميل الملاحظات الحالية إن وجدت
  }

  Future<void> markAppointmentAsCompleted(
      BuildContext context, String appointmentId) async {
    final String apiUrl =
        'http://10.0.2.2:8080/api/appointments-status/$appointmentId';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': 'completed'}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تحديث حالة الموعد إلى منتهي بنجاح')),
        );
        Navigator.pop(context); // الرجوع إلى الشاشة السابقة
      } else {
        throw Exception('Failed to update status: ${response.body}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء تحديث الحالة: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الموعد'),
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "اسم المتبرع: ${appointment['donorname']}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[400],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "اسم المحتاج: ${appointment['needyname']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "تاريخ الموعد: ${appointment['appointmentDateTime']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "الملاحظات : ${appointment['note']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "ملاحظات: ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'أضف ملاحظاتك هنا...',
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final appointmentId = appointment['id'];
                    if (appointmentId != null && appointmentId.isNotEmpty) {
                      updateAppointmentNotes(
                        context,
                        appointmentId,
                        _notesController.text,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('معرّف الموعد غير صالح')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text('تأكيد'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final appointmentId = appointment['id'];
                    print(appointmentId);
                    print(appointment);

                    if (appointmentId != null && appointmentId.isNotEmpty) {
                      markAppointmentAsCompleted(context, appointmentId);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('معرّف الموعد غير صالح')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text('إنهاء الموعد'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text('إلغاء'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
