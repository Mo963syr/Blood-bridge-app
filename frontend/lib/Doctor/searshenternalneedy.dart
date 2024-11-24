import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../donationrequestpage.dart';

Future<List<dynamic>> fetchData() async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:8080/api/blood-requests'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('فشل تحميل البيانات');
  }
}

class searchEnternalNeedy extends StatelessWidget {
  const searchEnternalNeedy({super.key});

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
                            builder: (context) => DonationRequestPage()),
                      );
                    },
                    icon: Icon(Icons.favorite, color: Colors.white),
                    label: Text(
                      "تبرع",
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
                      Navigator.pop(ctx);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('عرض البيانات'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // تحميل
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا توجد بيانات'));
          } else {
            List<dynamic> data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showDonationOptions(
                        context, data[index] as Map<String, dynamic>);
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        'Blood Type: ${data[index]['bloodType'] ?? 'نوع الدم غير متاح'}',
                        style:
                            TextStyle(fontWeight: FontWeight.bold), // لون النص
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Urgency Level: ${data[index]['urgencyLevel'] ?? 'خطورة الحالة غير متاحة'}'),
                          Text(
                              'Location: ${data[index]['location'] ?? 'مكان التواجد غير متاح'}'),
                          Text(
                              'Requested In: ${data[index]['createdAt'] ?? 'تاريخ الانشاء غير متاح'}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
