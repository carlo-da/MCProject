import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Placeholder imports for your screens (we will create/update these next)
import 'ui/screens/password_generator.dart';
import 'ui/screens/breach_check.dart'; 
// import 'ui/screens/password_manager.dart'; // We will build this
// import 'ui/screens/safety_tips.dart';      // We will build this
import 'ui/screens/settings_page.dart';       // We will build this
import 'ui/screens/password_manager.dart';
import 'ui/screens/safety_tips.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, 
  ));
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
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.redAccent,
        
        // Define the Red/White Color Scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.redAccent,
          primary: Colors.redAccent,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),

        // The Red Header
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white, // Text/Icon color
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.0),
        ),

        // The Bottom Navigation
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.grey[50],
          indicatorColor: Colors.redAccent.withOpacity(0.2),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
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

  // Temporary list until we refactor the other files
  final List<Widget> _screens = [
    const PasswordManager(), // Placeholder
    const PasswordGenerator(),
    const BreachChecker(),
    const SafetyTipsScreen(), // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CYBER GUARD"),
        actions: [
          // THE SETTINGS GEAR
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.lock_outline),
            selectedIcon: Icon(Icons.lock),
            label: 'Vault', // The Manager
          ),
          NavigationDestination(
            icon: Icon(Icons.password),
            label: 'Generate',
          ),
          NavigationDestination(
            icon: Icon(Icons.wifi_password),
            label: 'Breach',
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb_outline),
            selectedIcon: Icon(Icons.lightbulb),
            label: 'Tips', // The new Tips section
          ),
        ],
      ),
    );
  }
}