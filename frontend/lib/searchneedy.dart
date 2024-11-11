import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  // قائمة عينة للمحتاجين (يمكنك استبدالها ببيانات حقيقية من قاعدة البيانات)
  final List<Map<String, String>> needyList = [
    {
      "postedAgo": "قبل 3 ساعات",
      "bloodType": "A+",
    },
    {
      "postedAgo": "قبل يوم واحد",
      "bloodType": "O-",
    },
    {
      "postedAgo": "قبل ساعتين",
      "bloodType": "B+",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("بحث عن محتاجين"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: needyList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showDonationOptions(context, needyList[index]),
              child: Card(
                color: const Color.fromARGB(255, 254, 192, 187),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      // أيقونة الشخص
                      Icon(
                        Icons.person,
                        size: 40,
                        color: const Color.fromARGB(255, 98, 194, 1),
                      ),
                      SizedBox(width: 15),
                      // معلومات المحتاج
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "زمرة الدم: ${needyList[index]['bloodType'] ?? 'غير متوفرة'}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.redAccent,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              needyList[index]['postedAgo'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // أيقونة السهم للإشارة إلى إمكانية الضغط
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
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

  /// دالة لعرض خيارات التبرع عند الضغط على البطاقة
  void _showDonationOptions(BuildContext context, Map<String, String> needy) {
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
              Text(
                "تبرع ل${needy['name']}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                      // هنا يمكنك إضافة منطق التبرع
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("تم التبرع بنجاح!")),
                      );
                    },
                    icon: Icon(Icons.favorite, color: Colors.white),
                    label: Text("تبرع"),
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
                    label: Text("إلغاء"),
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
}
