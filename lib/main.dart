import 'package:flutter/material.dart';
import 'ui/screens/password_generator.dart';
import 'ui/screens/breach_check.dart';
import 'ui/screens/password_checker.dart';
import 'ui/screens/news_feed.dart';


void main() {
  runApp(CyberGuardApp());
}

class CyberGuardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber Guard',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Make sure these class names exactly match the ones in your screen files
  final List<Widget> _screens = [
    PasswordGeneratorScreen(),
    BreachCheckScreen(),
    PasswordCheckerScreen(),
    NewsFeedScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.vpn_key),
            label: 'Generator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Breach Check',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Checker',
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
