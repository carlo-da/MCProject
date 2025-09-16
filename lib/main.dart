import 'package:flutter/material.dart';
import 'ui/screens/password_generator.dart';
import 'ui/screens/password_checker.dart';
import 'ui/screens/breach_check.dart';
import 'ui/screens/news_feed.dart';

void main() {
  runApp(const CyberGuardApp());
}

class CyberGuardApp extends StatelessWidget {
  const CyberGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CyberGuard',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.lightBlue,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.lightBlue,
          unselectedItemColor: Colors.black54,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    PasswordGeneratorScreen(),
    PasswordCheckerScreen(),
    BreachCheckScreen(),
    NewsFeedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() {
    _currentIndex = index;
  }),
  showSelectedLabels: false, // remove label
  showUnselectedLabels: false, // remove label
  selectedItemColor: Colors.lightBlue,
  unselectedItemColor: Colors.black54,
  backgroundColor: Colors.white,
  type: BottomNavigationBarType.fixed,
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.vpn_key),
      label: 'Generator',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shield),
      label: 'Password check',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.speed),
      label: 'Breach Check',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.article),
      label: 'News',
    ),
  ],
),
    );
  }
}
