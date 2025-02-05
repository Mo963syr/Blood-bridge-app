import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'donationRequestCompleted.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لوحة تحكم الموظف',
      theme: AppTheme.theme,
      home: EmployeeDashboardPage(),
    );
  }
}

// App Constants and Theme
class AppTheme {
  static const Color primaryColor = Colors.red;
  static const Color secondaryColor = Colors.blue;
  static const Color successColor = Colors.green;

  static final ThemeData theme = ThemeData(
    primarySwatch: Colors.red,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    ),
  );
}

// Service Classes
class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/auth';

  static Future<Map<String, dynamic>> signup({
    required String role,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'role': role,
        'firstName': firstName,
        'lastName': lastName,
        'number': phone,
        'email': email,
        'password': password,
      }),
    );

    return {
      'status': response.statusCode,
      'data': jsonDecode(response.body),
    };
  }
}

// Main Pages
class EmployeeDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة تحكم الموظف'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DashboardCard(
              title: 'إنشاء حساب طبيب',
              icon: Icons.medical_services,
              color: AppTheme.secondaryColor,
              onTap: () => _navigateToCreateUser(context, 'doctor'),
            ),
            SizedBox(height: 16),
            DashboardCard(
              title: 'إنشاء حساب منسق توعوي',
              icon: Icons.group_add,
              color: AppTheme.successColor,
              onTap: () => _navigateToCreateUser(context, 'coordinator'),
            ),
            DashboardCard(
              title: 'طلبات التبرع المكتملة',
              icon: Icons.history,
              color: AppTheme.successColor,
              onTap: () => Navigator.push(
                // أضف هذا الجزء
                context,
                MaterialPageRoute(
                  builder: (context) => DonationRequestsPageCompleted(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCreateUser(BuildContext context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateUserPage(role: role)),
    );
  }
}

// Reusable Widgets
class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildIconContainer(),
              SizedBox(width: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(12),
      child: Icon(icon, color: color, size: 32),
    );
  }
}

class CreateUserPage extends StatefulWidget {
  final String role;

  const CreateUserPage({required this.role});

  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = {
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
    'phone': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'confirmPassword': TextEditingController(),
  };

  @override
  void dispose() {
    _controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إنشاء حساب ${_getRoleName()}'),
        backgroundColor: _getRoleColor(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextFields(),
              SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFields() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _controllers['firstName']!,
              label: 'الاسم',
              icon: Icons.person,
            ),
            CustomTextField(
              controller: _controllers['lastName']!,
              label: 'الكنية',
              icon: Icons.person_outline,
            ),
            CustomTextField(
              controller: _controllers['phone']!,
              label: 'رقم الهاتف',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            CustomTextField(
              controller: _controllers['email']!,
              label: 'البريد الإلكتروني',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              controller: _controllers['password']!,
              label: 'كلمة المرور',
              icon: Icons.lock,
              isPassword: true,
            ),
            CustomTextField(
              controller: _controllers['confirmPassword']!,
              label: 'تأكيد كلمة المرور',
              icon: Icons.lock_outline,
              isPassword: true,
              validator: (value) => value != _controllers['password']!.text
                  ? 'كلمتا المرور غير متطابقتين'
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _getRoleColor(),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: _submitForm,
      child: Text('إنشاء حساب', style: TextStyle(fontSize: 16)),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_controllers['password']!.text !=
        _controllers['confirmPassword']!.text) {
      _showSnackBar('كلمتا المرور غير متطابقتين');
      return;
    }

    final response = await AuthService.signup(
      role: widget.role,
      firstName: _controllers['firstName']!.text,
      lastName: _controllers['lastName']!.text,
      phone: _controllers['phone']!.text,
      email: _controllers['email']!.text,
      password: _controllers['password']!.text,
    );

    if (response['status'] == 201) {
      _handleSuccessResponse(response['data']);
    } else {
      _handleErrorResponse(response['data']);
    }
  }

  void _handleSuccessResponse(Map<String, dynamic> data) {
    if (data['message'] == 'Email is not available') {
      _showSnackBar('البريد الإلكتروني غير متاح');
    } else {
      Navigator.pop(context);
      _showSnackBar('تم إنشاء الحساب بنجاح');
    }
  }

  void _handleErrorResponse(Map<String, dynamic> data) {
    _showSnackBar('فشل في إنشاء الحساب: ${data['error'] ?? 'حدث خطأ ما'}');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Color _getRoleColor() =>
      widget.role == 'doctor' ? AppTheme.secondaryColor : AppTheme.successColor;

  String _getRoleName() => widget.role == 'doctor' ? 'طبيب' : 'منسق توعوي';
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator ?? _defaultValidator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppTheme.primaryColor),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) return 'الرجاء إدخال هذه الحقل';
    return null;
  }
}
