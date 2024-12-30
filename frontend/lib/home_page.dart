import 'package:flutter/material.dart';
import 'package:frontend/signin_page.dart';
import 'createrequest.dart';
import 'profilepage.dart';
import 'package:provider/provider.dart';
import 'package:frontend/donationrequestpage.dart';
import 'appointmentsUser.dart';
import 'setting_page.dart';
import 'Awareness Coordinato/mainCoordinator.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

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
  List<Map<String, dynamic>> _posts = [];

  ThemeData get themeData => _themeData;
  List<Map<String, dynamic>> get posts => _posts;

  void setDarkMode() {
    _themeData = ThemeData.dark();
    notifyListeners();
  }

  void setLightMode() {
    _themeData = ThemeData.light();
    notifyListeners();
  }

  void addPost(Map<String, dynamic> post) {
    _posts.add(post);
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

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RequestPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DonationRequestPage()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AppointmentsPage()),
      );
    } else if (index == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage()),
      );
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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AwarenessCoordinatorPage()), // فتح صفحة المنسق التوعوي
              );
            },
          ),
        ],
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView.builder(
            itemCount: themeProvider.posts.length,
            itemBuilder: (context, index) {
              var post = themeProvider.posts[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (post['image'] != null)
                          Image.file(
                            post['image'],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        if (post['video'] != null)
                          Container(
                            height: 200,
                            child: VideoPlayer(
                              VideoPlayerController.file(post['video'])
                                ..initialize().then((_) {
                                  setState(() {});
                                  // Autoplay video
                                  VideoPlayerController.file(post['video'])
                                      .play();
                                }),
                            ),
                          ),
                        SizedBox(height: 8),
                        Text(
                          post['text'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.thumb_up),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.comment),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
              _buildNavItem(Icons.history, 'مواعيد', 4),
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
