import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'widgets/custom_header.dart';

class BreachCheckScreen extends StatefulWidget {
  const BreachCheckScreen({super.key});

  @override
  _BreachCheckScreenState createState() => _BreachCheckScreenState();
}

class _BreachCheckScreenState extends State<BreachCheckScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = "";
  Color _borderColor = Colors.grey;

  Future<void> _checkPassword(String password) async {
    if (password.isEmpty) return;

    // Hash password with SHA-1
    var bytes = utf8.encode(password);
    var digest = sha1.convert(bytes).toString().toUpperCase();

    String prefix = digest.substring(0, 5);
    String suffix = digest.substring(5);

    var url = Uri.parse("https://api.pwnedpasswords.com/range/$prefix");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      bool found = response.body.contains(suffix);

      setState(() {
        if (found) {
          _result = "⚠️ This password has been breached!";
          _borderColor = Colors.red;
        } else {
          _result = "✅ This password is safe.";
          _borderColor = Colors.green;
        }
      });
    } else {
      setState(() {
        _result = "Error checking password.";
        _borderColor = Colors.grey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomHeader(title: "Breach Checker"), //gradient header
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: _borderColor, width: 3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _controller,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter password to check",
                          hintStyle: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _checkPassword(_controller.text),
                      child: const Text("Check Breach"),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _result,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
