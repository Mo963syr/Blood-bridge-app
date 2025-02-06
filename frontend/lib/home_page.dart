import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'signin_page.dart';
import 'createrequest.dart';
import 'profilepage.dart';
import 'donationrequestpage.dart';
import 'appointmentsUser.dart';
import 'setting_page.dart';
import 'services/user_preferences.dart';
import 'package:frontend/requestForOther.dart';
import 'package:frontend/historyPage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light();

  ThemeData get themeData => _themeData;

  void setDarkMode() {
    _themeData = ThemeData.dark();
    notifyListeners();
  }

  void setLightMode() {
    _themeData = ThemeData.light();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;
  bool isLoading = true;
  List<Map<String, dynamic>> post = [];
  List<Map<String, dynamic>> count = [];
  int req = 0;
  int donrequestcount = 0;
  int requestForOtercount = 0;
  @override
  void initState() {
    super.initState();
    fetchPosts();
    reqCount();
  }

  // @override
  // void initStatem() {
  //   super.initState();
  //   reqCount();
  // }

  Future<void> fetchPosts() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8080/api/posts'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          post = data.map((e) => e as Map<String, dynamic>).toList();
          isLoading = false;
          print(post);
          print(response.statusCode);
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

  Future<void> reqCount() async {
    try {
      String? userId = await UserPreferences.getUserId();
      if (userId == null) {
        print('User ID not found');
        return;
      }
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8080/api/requests/donation-requests/count?userId=$userId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          req = data['requestcount'] ?? 'لا توجد بيانات';
          donrequestcount = data['donrequestcount'] ?? 'لا توجد بيانات';
          requestForOtercount = data['requestForOtercount'] ?? 'لا توجد بيانات';
          print('reqcount :${req}');
          print('userid :${userId}');
          print(response.statusCode);
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

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else if (index == 1) {
      reqCount();
      // print(req);
      if (req >= 1) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePage()),
        // );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لا يمكنك انشاء طلب جديد لديك طلب سابق')),
        );
      } else if (donrequestcount >= 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('لا يمكنك انشاء طلب جديد لديك طلب  تبرع سابق')),
        );
      } else if (req == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RequestPage()),
        );
      }
    } else if (index == 3) {
      reqCount();
      if (donrequestcount.toInt() >= 1) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePage()),
        // );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لا يمكنك انشاء طلب جديد لديك طلب سابق')),
        );
      } else if (donrequestcount == 0 && req == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DonationRequestPage()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لا ')),
        );
      }
      if (req >= 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('لا يمكنك انشاء طلب تبرع لديك طلب حاجة ')),
        );
      }
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Historypage()),
      );
    } else if (index == 5) {
      reqCount();
      if (requestForOtercount.toInt() >= 3) {
        print(requestForOtercount);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePage()),
        // );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'لا يمكنك انشاء طلب للغير جديد لديك ${requestForOtercount} طلبات سابقة')),
        );
      } else if (requestForOtercount < 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RequestOtherPage()),
        );
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الصفحة الرئيسية'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : post.isEmpty
              ? Center(
                  child: Text(
                    'لاتوجد منشورات حالياً',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: post.length,
                  itemBuilder: (context, index) {
                    final posts = post[index];
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                backgroundImage:
                                    NetworkImage(posts['userImage'] ?? ''),
                              ),
                              title: Text(
                                posts['username'] ?? 'مستخدم مجهول',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle:
                                  Text('تم النشر منذ ${posts['time']} ساعة'),
                              trailing: Icon(Icons.more_vert),
                            ),
                            if (posts['postImage'] != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  posts['postImage']!,
                                  height: 300,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Center(
                                    child: Text(
                                      posts['title'] ?? 'عنوان غير متوفر',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    posts['content'] ?? 'محتوى غير متوفر',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.favorite_border),
                                      SizedBox(width: 120),
                                      Icon(Icons.comment_outlined),
                                      SizedBox(width: 120),
                                      Icon(Icons.send),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFFC62828),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.person, 'الملف الشخصي', 0),
              _buildNavItem(Icons.add_circle, "طلب حاجة", 1),
              _buildNavItem(Icons.home, 'الرئيسية', 2),
              _buildNavItem(Icons.search, "طلب تبرع", 3),
              _buildNavItem(Icons.history, 'سجلاتي', 4),
              _buildNavItem(Icons.favorite, "طلب لغيري", 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: _selectedIndex == index ? Colors.white : Colors.white70,
              size: 22,
            ),
            SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: _selectedIndex == index ? Colors.white : Colors.white70,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
