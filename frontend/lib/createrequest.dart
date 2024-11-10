import 'package:flutter/material.dart';

void main() {
  runApp(RequestPage());
}

class RequestPage extends StatelessWidget {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? selectedBloodType;
  String? selecteddanger;
  final List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];
  final List<String> danger = [
    'حرجة',
    'مستعجلة',
    'قابلة للانتظار',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إنشاء طلب حاجة'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.red,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      hintText: "مكان التواجد الحالي",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      prefixIcon: const Icon(Icons.home)),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      hintText: "  فصيلة الدم المطلوبة",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      prefixIcon: const Icon(Icons.bloodtype)),
                  value: selectedBloodType,
                  items: bloodTypes.map((bloodType) {
                    return DropdownMenuItem(
                      value: bloodType,
                      child: Text(bloodType),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedBloodType = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                      hintText: "رقم الهاتف",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      prefixIcon: const Icon(Icons.phone)),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      hintText: "خطورة الحالة",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      prefixIcon: const Icon(Icons.search)),
                  value: selecteddanger,
                  items: danger.map((danger) {
                    return DropdownMenuItem(
                      value: danger,
                      child: Text(danger),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selecteddanger = value;
                  },
                ),
                SizedBox(height: 35.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print("تم إرسال الطلب");
                      },
                      child: Text('إرسال الطلب'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print("تم إلغاء الطلب");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('الروجوع'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
