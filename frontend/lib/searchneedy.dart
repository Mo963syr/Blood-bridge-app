import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  // قائمة عينة للمحتاجين (يمكنك استبدالها ببيانات حقيقية من قاعدة البيانات)
  final List<Map<String, String>> needyList = [
    {
      "name": "محمد علي",
      "postedAgo": "قبل 3 ساعات",
    },
    {
      "name": "علي حسن",
      "postedAgo": "قبل يوم واحد",
    },
    {
      "name": "أمينة خليل",
      "postedAgo": "قبل ساعتين",
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
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      needyList[index]['name'] ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
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
            );
          },
        ),
      ),
    );
  }
}
