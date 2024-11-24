import 'package:flutter/material.dart';
import 'dart:math';

class Searshexternalneedy extends StatelessWidget {
  final List<Map<String, dynamic>> externalRequests = [
    {
      'location': 'دمشق',
      'bloodType': 'A+',
      'phoneNumber': '0551234567',
      'urgency': 'high',
      //'reportImage': '../../assets/images/b.png',
      'requestTime': DateTime.now().subtract(Duration(hours: 2)),
    },
    {
      'location': 'حماة',
      'bloodType': 'O-',
      'phoneNumber': '0567654321',
      'urgency': 'medium',
      //'reportImage': 'assets/images/sample_report.png',
      'requestTime': DateTime.now().subtract(Duration(hours: 5)),
    },
    {
      'location': 'ريف دمشق',
      'bloodType': 'AB+',
      'phoneNumber': '0579988776',
      'urgency': 'low',
      //'reportImage': 'assets/images/sample_report.png',
      'requestTime': DateTime.now().subtract(Duration(hours: 10)),
    },
  ];

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'high':
        return Colors.red[300]!;
      case 'medium':
        return Colors.amber[300]!;
      case 'low':
        return Colors.green[300]!;
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
        title: Text('طلبات الحاجة الخارجية'),
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: externalRequests.length,
          itemBuilder: (context, index) {
            final request = externalRequests[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestDetailsPage(request: request),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                margin: EdgeInsets.only(bottom: 16),
                color: _getUrgencyColor(request['urgency']),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الموقع: ${request['location']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'فصيلة الدم: ${request['bloodType']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'الوقت: ${_timeAgo(request['requestTime'])}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'مستوى الخطورة: ${request['urgency']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.warning_rounded,
                        color: Colors.black,
                        size: 40,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}

class RequestDetailsPage extends StatelessWidget {
  final Map<String, dynamic> request;

  RequestDetailsPage({required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الطلب'),
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الموقع: ${request['location']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'فصيلة الدم: ${request['bloodType']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'رقم الهاتف: ${request['phoneNumber']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'مستوى الخطورة: ${request['urgency']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'تم الطلب منذ: ${DateTime.now().difference(request['requestTime']).inHours} ساعات',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Center(
              child: request['reportImage'] != null
                  ? Image.asset(
                      request['reportImage'],
                      fit: BoxFit.cover,
                    )
                  : Text('لا توجد صورة مرفقة'),
            ),
          ],
        ),
      ),
    );
  }
}
