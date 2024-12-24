import 'package:flutter/material.dart';
import 'package:frontend/Doctor/ScheduleAppointmentPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchData() async {
  final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/requests/blood-requests/approve'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('فشل تحميل البيانات');
  }
}

class ApprovedRequestsPage extends StatelessWidget {
  const ApprovedRequestsPage(
      {super.key, required List<Map<String, dynamic>> approvedRequests});

  void _showDonationOptions(BuildContext context, Map<String, dynamic> needy) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              Text(
                "زمرة الدم: ${needy['bloodType']}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ScheduleAppointmentPage(needy: needy),
                        ),
                      );
                    },
                    icon: Icon(Icons.favorite, color: Colors.white),
                    label: Text(
                      "تحديد موعد",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigator.pop(ctx);
                    },
                    icon: Icon(Icons.cancel, color: Colors.white),
                    label: Text(
                      "إلغاء",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'high':
        return Color.fromARGB(255, 244, 130, 130); // 
      case 'medium':
        return Color.fromARGB(255, 245, 222, 148); // 
      case 'low':
        return Color.fromARGB(255, 175, 246, 179); // 
      default:
        return Colors.grey[300]!;
    }
  }

  String _timeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} دقائق مضت';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ساعات مضت';
    } else {
      return '${difference.inDays} أيام مضت';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الطلبات الموافق عليها'),
        backgroundColor: Colors.red[400], 
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا توجد بيانات'));
          } else {
            List<dynamic> data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final request = data[index];
                  return GestureDetector(
                    onTap: () {
                      _showDonationOptions(
                          context, request as Map<String, dynamic>);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.only(bottom: 16),
                      color: _getUrgencyColor(request['urgencyLevel']),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الموقع: ${request['location'] ?? 'غير متاح'}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'فصيلة الدم: ${request['bloodType'] ?? 'غير متاح'}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'الوقت: ${_timeAgo(DateTime.parse(request['createdAt']))}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'مستوى الخطورة: ${request['urgencyLevel'] ?? 'غير متاح'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.green,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
