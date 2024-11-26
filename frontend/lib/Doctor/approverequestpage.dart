import 'package:flutter/material.dart';

class ApprovedRequestsPage extends StatelessWidget {
  final List<Map<String, dynamic>> approvedRequests;

  ApprovedRequestsPage({required this.approvedRequests});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الطلبات الموافق عليها'),
        backgroundColor: Colors.green[400],
        centerTitle: true,
      ),
      body: approvedRequests.isEmpty
          ? Center(
              child: Text(
                'لا توجد طلبات تمت الموافقة عليها.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: approvedRequests.length,
              itemBuilder: (context, index) {
                final request = approvedRequests[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الموقع: ${request['location']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'فصيلة الدم: ${request['bloodType']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'وقت التفرغ: ${request['availableTime']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'تاريخ الإرسال: ${_timeAgo(request['submissionDate'])}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 1) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}
