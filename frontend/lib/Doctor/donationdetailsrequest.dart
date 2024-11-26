import 'package:flutter/material.dart';
import '';

class DonationDetailsPage extends StatelessWidget {
  final Map<String, dynamic> request;
  final Function(Map<String, dynamic>) onApprove;

  DonationDetailsPage({required this.request, required this.onApprove});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل طلب التبرع'),
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
              'وقت التفرغ: ${request['availableTime']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'تاريخ الإرسال: ${_timeAgo(request['submissionDate'])}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'الوزن: ${request['weight']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            request['medicalReport'] != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التحليل الطبي:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Image.asset(
                        request['medicalReport'],
                        fit: BoxFit.cover,
                      ),
                    ],
                  )
                : Text(
                    'لا توجد صورة للتحليل الطبي',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // إجراء الموافقة
                    onApprove(request);
                    Navigator.pop(context);
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
