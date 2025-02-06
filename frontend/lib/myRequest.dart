import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/Doctor/ScheduleAppointmentPage.dart';
import 'services/user_preferences.dart';

class MyRequest extends StatefulWidget {
  @override
  State<MyRequest> createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {
  List<Map<String, dynamic>> donationRequests = [];
  List<Map<String, dynamic>> bloodRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDonationRequests();
  }

  Future<void> fetchDonationRequests() async {
    try {
      // Fetch userId from UserPreferences
      String? userId = await UserPreferences.getUserId();
      if (userId == null) {
        print('User ID not found');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Make the HTTP GET request
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8080/api/requests/donation-request-user?id=$userId'),
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          donationRequests =
              List<Map<String, dynamic>>.from(data['donationrequest']);
          bloodRequests = List<Map<String, dynamic>>.from(data['bloodrequest']);
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
        title: Text('طلبات التبرع'),
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : donationRequests.isEmpty && bloodRequests.isEmpty
              ? Center(child: Text('لا توجد طلبات متوفرة حاليًا'))
              : ListView(
                  children: [
                    if (donationRequests.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'طلبات التبرع بالدم',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ...donationRequests.map((request) =>
                        _buildDonationRequestItem(request, isDonation: true)),
                    if (bloodRequests.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'طلبات الدم',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ...bloodRequests.map((request) =>
                        _buildDonationRequestItem(request, isDonation: false)),
                  ],
                ),
    );
  }

  Widget _buildDonationRequestItem(Map<String, dynamic> request,
      {required bool isDonation}) {
    return Card(
      color: request['requestStatus'] == 'active'
          ? Colors.green[100]
          : Colors.grey[100],
      child: ListTile(
        title: Text('الموقع: ${request['location']}'),
        subtitle: Text(
          'فصيلة الدم: ${request['bloodType']}\n'
          'منذ: ${_timeAgo(DateTime.parse(request['createdAt']))}',
        ),
        trailing: Text('وقت التفرغ: ${request['AvailabilityPeriod']}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DonationDetailsPage(request: request, isDonation: isDonation),
            ),
          );
        },
      ),
    );
  }
}

class DonationDetailsPage extends StatelessWidget {
  final Map<String, dynamic> request;
  final bool isDonation;

  DonationDetailsPage({required this.request, required this.isDonation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الطلب'),
        backgroundColor: Colors.red[400],
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
              'وقت التفرغ: ${request['AvailabilityPeriod']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'الحالة: ${request['requestStatus']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            if (isDonation)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التقرير الطبي:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  if (request['medecalreport'] != null &&
                      (request['medecalreport'].endsWith('.jpg') ||
                          request['medecalreport'].endsWith('.png')))
                    Image.asset(
                      request['medecalreport'],
                      width: 800,
                      height: 500,
                      errorBuilder: (context, error, stackTrace) {
                        return Text('فشل في تحميل الصورة.');
                      },
                    )
                  else
                    Text(
                      'الرابط غير صالح أو ليس صورة.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                ],
              ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle approval
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'موافقة',
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
                  child: Text('رفض', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
