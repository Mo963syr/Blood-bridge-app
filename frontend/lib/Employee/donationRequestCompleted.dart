import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'إدارة طلبات التبرع',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: DonationRequestsPageCompleted(),
    );
  }
}

class DonationRequestsPageCompleted extends StatefulWidget {
  @override
  State<DonationRequestsPageCompleted> createState() =>
      _DonationRequestsPageCompletedState();
}

class _DonationRequestsPageCompletedState
    extends State<DonationRequestsPageCompleted> {
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
          'http://10.0.2.2:8080/api/requests/donation-request-completed'));
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
        title: Text('طلبات التبرع المكتملة'),
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : donationrequest.isEmpty
              ? Center(child: Text('لا توجد طلبات متوفرة حاليًا'))
              : RefreshIndicator(
                  onRefresh: fetchdonationrequest,
                  child: ListView.builder(
                    itemCount: donationrequest.length,
                    itemBuilder: (context, index) {
                      final request = donationrequest[index];
                      return _buildDonationRequestItem(request);
                    },
                  ),
                ),
    );
  }

  Widget _buildDonationRequestItem(Map<String, dynamic> request) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('الاسم: ${request['user']['firstName']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الموقع: ${request['location']}'),
            Text('فصيلة الدم: ${request['bloodType']}'),
            Text('منذ: ${_timeAgo(DateTime.parse(request['createdAt']))}'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DonationDetailsPage(request: request),
            ),
          );
          if (result == true) {
            fetchdonationrequest();
          }
        },
      ),
    );
  }
}

class DonationDetailsPage extends StatelessWidget {
  final Map<String, dynamic> request;

  DonationDetailsPage({required this.request});

  Future<void> _deleteRequest(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من رغبتك في حذف هذا الطلب؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8080/api/requests/delete-donation-request'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'requestId': request['_id']}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حذف الطلب بنجاح!')),
        );
        Navigator.of(context).pop(true);
      } else {
        throw Exception('فشل في الحذف: ${response.body}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء الحذف: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الطلب'),
        backgroundColor: Colors.red[400],
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () => _deleteRequest(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('الاسم:', request['user']['firstName']),
            _buildDetailItem('الموقع:', request['location']),
            _buildDetailItem('فصيلة الدم:', request['bloodType']),
            _buildDetailItem('وقت التفرغ:', request['AvailabilityPeriod']),
            _buildDetailItem('الوزن:', '${request['Weight']} kg'),
            SizedBox(height: 20),
            if (request['medecalreport'] != null)
              _buildMedicalReport(request['medecalreport']),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _deleteRequest(context),
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text('حذف الطلب', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalReport(String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التقرير الطبي:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(
            request['medecalreport'],
            width: 800,
            height: 500,
            errorBuilder: (context, error, stackTrace) {
              return Text('فشل في تحميل الصورة.');
            },
          ),
        ),
      ],
    );
  }
}
