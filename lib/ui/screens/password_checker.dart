import 'package:flutter/material.dart';

class PasswordCheckerScreen extends StatefulWidget {
  const PasswordCheckerScreen({super.key});

  @override
  _PasswordCheckerScreenState createState() => _PasswordCheckerScreenState();
}

class _PasswordCheckerScreenState extends State<PasswordCheckerScreen> {
  String password = '';
  String strength = 'Enter a password';

  void checkStrength(String input) {
    setState(() {
      password = input;
      if (input.length < 6) {
        strength = 'Too short';
      } else if (RegExp(r'^[a-zA-Z]+$').hasMatch(input)) {
        strength = 'Weak';
      } else if (RegExp(r'(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%^&*])').hasMatch(input)) {
        strength = 'Strong';
      } else {
        strength = 'Moderate';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Password Strength Checker'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black),
      body: Center(
  child: SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Check Password Strength',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        TextField(
          onChanged: checkStrength,
          decoration: InputDecoration(
            labelText: 'Enter password',
            prefixIcon: Icon(Icons.lock_outline),
          ),
          obscureText: true,
        ),
        SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
        child: Text(
          'Strength: $strength',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: strength == 'Strong'
                ? Colors.greenAccent
                : strength == 'Weak'
                    ? Colors.redAccent
                    : Colors.orangeAccent,
            ),
          ),
        ),
      ],
    ),
    ),
  ),
  );

    }
  }