import 'package:flutter/material.dart';
import 'donationdetailsrequest.dart';

class DonationRequestsPage extends StatelessWidget {
  final Function(Map<String, dynamic>) onApprove;

  DonationRequestsPage({required this.onApprove});

  @override
  Widget build(BuildContext context) {
    // قائمة طلبات التبرع الافتراضية
    final List<Map<String, dynamic>> donationRequests = [
      {
        'location': 'دمشق',
        'bloodType': 'A+',
        'availableTime': '10:00 صباحًا',
        'weight': '75 كغ',
        'submissionDate': DateTime.now(),
        //'medicalReport': 'assets/sample_report.png',
      },
      {
        'location': 'دjمشق',
        'bloodType': 'A+',
        'availableTime': '10:00 صباحًا',
        'weight': '75 كغ',
        'submissionDate': DateTime.now(),
        //'medicalReport': 'assets/sample_report.png',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('طلبات التبرع'),
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: donationRequests.length,
        itemBuilder: (context, index) {
          final request = donationRequests[index];
          return Card(
            child: ListTile(
              title: Text('الموقع: ${request['location']}'),
              subtitle: Text('فصيلة الدم: ${request['bloodType']}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DonationDetailsPage(
                      request: request,
                      onApprove: (approvedRequest) {
                        onApprove(approvedRequest);
                      },
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
