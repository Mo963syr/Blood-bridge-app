import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart%20';

class Searshexternalneedy extends StatefulWidget {
  @override
  _SearshexternalneedyState createState() => _SearshexternalneedyState();
}

class _SearshexternalneedyState extends State<Searshexternalneedy> {
  List<Map<String, dynamic>> externalRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExternalRequests();
  }

  Future<void> fetchExternalRequests() async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8080/api/requests/blood-requests/external'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          externalRequests =
              data.map((e) => e as Map<String, dynamic>).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $error');
    }
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'high':
        return const Color.fromARGB(255, 244, 130, 130)!;
      case 'medium':
        return const Color.fromARGB(255, 245, 222, 148)!;
      case 'low':
        return const Color.fromARGB(255, 175, 246, 179)!;
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : externalRequests.isEmpty
              ? Center(child: Text('لا توجد طلبات حالياً'))
              : Padding(
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
                              builder: (context) =>
                                  RequestDetailsPage(request: request),
                            ),
                          );
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
                                      'الوقت: ${_timeAgo(DateTime.parse(request['createdAt']))}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'مستوى الخطورة: ${request['urgencyLevel']}',
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
    print('مسار الصورة: ${request['medecalreport']}');

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصي الطلب'),
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
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
                'مستوى الخطورة: ${request['urgencyLevel']}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'تم الطلب منذ: ${DateTime.now().difference(DateTime.parse(request['createdAt'])).inHours} ساعات',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              if (request['medecalreport'] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التقرير الطبي:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Image.asset('${request['medecalreport']}'),
                  ],
                )
              else
                Text(
                  'لا يوجد تقرير طبي مرفق أو الملف غير موجود.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
