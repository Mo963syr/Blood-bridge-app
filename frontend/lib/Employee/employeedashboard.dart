import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لوحة تحكم الموظف',
      theme: ThemeData(primarySwatch: Colors.red),
      home: EmployeeDashboardPage(),
    );
  }
}

class EmployeeDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة تحكم الموظف'),
        backgroundColor: Colors.red[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardCard(
              title: 'إنشاء حساب طبيب',
              icon: Icons.medical_services,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateDoctorPage()),
                );
              },
            ),
            SizedBox(height: 16),
            DashboardCard(
              title: 'إنشاء حساب منسق توعوي',
              icon: Icons.group_add,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateCoordinatorPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  DashboardCard({
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
              Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(12),
                child: Icon(icon, color: color, size: 32),
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateDoctorPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  CreateDoctorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إنشاء حساب طبيب'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    _buildTextField(
                      label: 'الاسم',
                      icon: Icons.person,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      label: 'الكنية',
                      icon: Icons.account_circle,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      label: 'رقم الهاتف',
                      icon: Icons.phone,
                      inputType: TextInputType.phone,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      label: 'البريد الإلكتروني',
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      label: 'كلمة المرور',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      label: 'تأكيد كلمة المرور',
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تم إنشاء الحساب بنجاح')),
                          );
                        }
                      },
                      child: Text(
                        'إنشاء حساب',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextFormField(
      keyboardType: inputType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال $label';
        }
        return null;
      },
    );
  }
}

class CreateCoordinatorPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  CreateCoordinatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إنشاء حساب منسق توعوي'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    _buildTextField(
                      label: 'الاسم',
                      icon: Icons.person,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      label: 'الكنية',
                      icon: Icons.account_circle,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      label: 'رقم الهاتف',
                      icon: Icons.phone,
                      inputType: TextInputType.phone,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      label: 'البريد الإلكتروني',
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      label: 'كلمة المرور',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      label: 'تأكيد كلمة المرور',
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تم إنشاء الحساب بنجاح')),
                          );
                        }
                      },
                      child: Text(
                        'إنشاء حساب',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextFormField(
      keyboardType: inputType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال $label';
        }
        return null;
      },
    );
  }
}
