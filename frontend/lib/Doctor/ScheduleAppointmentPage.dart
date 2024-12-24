import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScheduleAppointmentPage extends StatefulWidget {
  final Map<String, dynamic> needy;

  ScheduleAppointmentPage({Key? key, required this.needy}) : super(key: key);

  @override
  _ScheduleAppointmentPageState createState() =>
      _ScheduleAppointmentPageState();
}

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<Map<String, dynamic>> _needyList = [];
  Map<String, dynamic>? _selectedNeedy;
  bool _isLoading = true;

  Future<void> _fetchNeedyList() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/requests/blood-requests-with-user'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _needyList = data.map((item) => item as Map<String, dynamic>).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch needy list');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في جلب البيانات: $e')),
      );
    }
  }

  Future<void> _sendAppointmentToServer() async {
    if (_selectedDate == null || _selectedTime == null || _selectedNeedy == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى تحديد المحتاج والتاريخ والوقت')),
      );
      return;
    }

    final DateTime appointmentDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final Map<String, dynamic> requestBody = {
      'needyId': _selectedNeedy?['id']?.toString() ?? '',
      'appointmentDateTime': appointmentDateTime.toIso8601String(),
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/appointments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تحديد الموعد بنجاح')),
        );
        Navigator.pop(context);
      } else {
        final errorMessage = json.decode(response.body)['message'] ?? 'خطأ غير معروف';
        throw Exception('فشل في تحديد الموعد: $errorMessage');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNeedyList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تحديد موعد'),
        backgroundColor: Colors.red[400],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'تفاصيل الحالة:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'الموقع: ${widget.needy['location'] ?? 'غير متاح'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'فصيلة الدم: ${widget.needy['bloodType'] ?? 'غير متاح'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'مستوى الخطورة: ${widget.needy['urgencyLevel'] ?? 'غير متاح'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            Text(
              'اختر محتاجًا:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<Map<String, dynamic>>(
                    decoration: InputDecoration(
                      labelText: 'اختر محتاجًا',
                      border: OutlineInputBorder(),
                    ),
                    items: _needyList.map((needy) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: needy,
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: _getUrgencyColor(needy['urgencyLevel']),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                    color: _getUrgencyTextColor(needy['urgencyLevel']),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      needy['user']['firstName'] ?? 'غير معروف',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: _getUrgencyTextColor(needy['urgencyLevel']),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'مستوى الخطورة: ${needy['urgencyLevel'] ?? 'غير معروف'}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _getUrgencyTextColor(needy['urgencyLevel']),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedNeedy = value;
                      });
                    },
                    value: _selectedNeedy,
                  ),
            SizedBox(height: 30),
            Text(
              'حدد تاريخ ووقت الموعد:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'التاريخ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              controller: TextEditingController(
                text: _selectedDate == null
                    ? ''
                    : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'الوقت',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              readOnly: true,
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _selectedTime = pickedTime;
                  });
                }
              },
              controller: TextEditingController(
                text: _selectedTime == null
                    ? ''
                    : '${_selectedTime!.hour}:${_selectedTime!.minute}',
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: _sendAppointmentToServer,
                icon: Icon(Icons.check),
                label: Text('تأكيد الموعد'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getUrgencyColor(String? urgencyLevel) {
    switch (urgencyLevel) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getUrgencyTextColor(String? urgencyLevel) {
    switch (urgencyLevel) {
      case 'high':
      case 'medium':
      case 'low':
        return Colors.white;
      default:
        return Colors.black;
    }
  }
}
