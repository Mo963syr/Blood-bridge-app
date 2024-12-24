import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/Doctor/ScheduleAppointmentPage.dart';

class DonationRequestsPageApproved extends StatefulWidget {
  final Function(Map<String, dynamic>) onApprove;

  DonationRequestsPageApproved({required this.onApprove});

  @override
  State<DonationRequestsPageApproved> createState() =>
      _DonationRequestsPageApprovedState();
}

class _DonationRequestsPageApprovedState
    extends State<DonationRequestsPageApproved> {
  List<Map<String, dynamic>> donationrequest = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchdonationrequest();
  }

  Future<void> fetchdonationrequest() async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8080/api/requests/donation-request-approved'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          donationrequest = data.map((e) => e as Map<String, dynamic>).toList();
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
          : donationrequest.isEmpty
              ? Center(child: Text('لا توجد طلبات متوفرة حاليًا'))
              : ListView.builder(
                  itemCount: donationrequest.length,
                  itemBuilder: (context, index) {
                    final request = donationrequest[index];
                    return _buildDonationRequestItem(request);
                  },
                ),
    );
  }

  Widget _buildDonationRequestItem(Map<String, dynamic> request) {
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
              builder: (context) => DonationDetailsPage(
                request: request,
                onApprove: widget.onApprove,
              ),
            ),
          );
        },
      ),
    );
  }
}

class DonationDetailsPage extends StatelessWidget {
  final Map<String, dynamic> request;
  final Function(Map<String, dynamic>) onApprove;

  DonationDetailsPage({required this.request, required this.onApprove});

  Future<void> _updateRequestStatus(BuildContext context, String status) async {
    final String apiUrl =
        'http://10.0.2.2:8080/api/requests/update-status-donation';
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
// erorr in id

          'requestId': request['_id'], // معرّف الطلب
          'requestStatus': status, // الحالة الجديدة
        }),
      );

      if (response.statusCode == 200) {
        // إذا تمت العملية بنجاح
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تعديل الحالة بنجاح!')),
        );
        Navigator.pop(context); 
      } else {
        throw Exception('Failed to update status: ${response.body}');
      }
    } catch (error) {
      // في حالة حدوث خطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء تعديل الحالة: $error')),
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    print('مسار الصورة: ${request['medecalreport']}');
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
              'وقت التفرغ: ${request['AvailabilityPeriod']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            // Text(
            //   // 'تاريخ الإرسال: ${_timeAgo(request['createdAt'])}',
            //   style: TextStyle(fontSize: 16),
            // ),
            SizedBox(height: 20),
            Text(
              'الوزن: ${request['Weight']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            if (request['medecalreport'] != null &&
                    request['medecalreport'].endsWith('.jpg') ||
                request['medecalreport'].endsWith('.png'))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التقرير الطبي:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Image.asset(
                    request['medecalreport'],
                    width: 800,
                    height: 500,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('فشل في تحميل الصورة.');
                    },
                  ),
                ],
              )
            else
              Text(
                'الرابط غير صالح أو ليس صورة.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showDonationOptions(
                        context, request as Map<String, dynamic>);
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
