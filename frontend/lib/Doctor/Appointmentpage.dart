import 'package:flutter/material.dart';

class AppointmentsPage extends StatelessWidget {
  final List<Map<String, String>> appointments = [
    {
      "donorName": "محمد علي",
      "recipientName": "أحمد سعيد",
      "appointmentDate": "2024-12-30"
    },
    {
      "donorName": "خالد يوسف",
      "recipientName": "سمير حسن",
      "appointmentDate": "2024-12-28"
    },
    {
      "donorName": "عمر فؤاد",
      "recipientName": "محمود عبد الله",
      "appointmentDate": "2024-12-27"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المواعيد'),
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      body: appointments.isEmpty
          ? Center(
              child: Text(
                'لا توجد مواعيد حالياً.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentDetailsPage(
                            appointment: appointment,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "اسم المتبرع: ${appointment['donorName']}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[400],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "اسم المحتاج: ${appointment['recipientName']}",
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "تاريخ الموعد: ${appointment['appointmentDate']}",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class AppointmentDetailsPage extends StatelessWidget {
  final Map<String, String> appointment;

  AppointmentDetailsPage({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الموعد'),
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "اسم المتبرع: ${appointment['donorName']}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[400],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "اسم المحتاج: ${appointment['recipientName']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "تاريخ الموعد: ${appointment['appointmentDate']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "ملاحظات:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'أضف ملاحظاتك هنا...',
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // ضع هنا الكود المطلوب عند التأكيد
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text('تأكيد'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text('إلغاء'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
