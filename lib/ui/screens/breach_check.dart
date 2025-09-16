import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';

class BreachCheckScreen extends StatefulWidget {
  @override
  _BreachCheckScreenState createState() => _BreachCheckScreenState();
}

class _BreachCheckScreenState extends State<BreachCheckScreen> {
  TextEditingController passwordController = TextEditingController();
  String result = '';
  bool isLoading = false;
  bool _isChecking = false;

  Future<void> checkBreach() async {
    final password = passwordController.text.trim();
    if (password.isEmpty) return;

    setState(() {
      isLoading = true;
      result = '';
    });

    try {
      final hash = sha1.convert(utf8.encode(password)).toString().toUpperCase();
      final prefix = hash.substring(0, 5);
      final suffix = hash.substring(5);

      final url = Uri.parse('https://api.pwnedpasswords.com/range/$prefix');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final lines = response.body.split('\n');
        final found = lines.any((line) => line.startsWith(suffix));
        setState(() {
          result = found
              ? '⚠️ This password has been breached before!'
              : '✅ Safe: No breach found.';
        });
      } else {
        setState(() {
          result = 'Error fetching data';
        });
      }
    } catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  void copyResult() {
    if (result.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: result));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Result copied to clipboard')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Breach Check'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 20),
              AnimatedScale(
                scale: _isChecking ? 0.95 : 1.0,
                duration: Duration(milliseconds: 100),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() => _isChecking = true);
                    await checkBreach();
                    await Future.delayed(Duration(milliseconds: 100));
                    setState(() => _isChecking = false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                  ),
                  child: Text('Check Password'),
                ),
              ),
              SizedBox(height: 20),
              if (isLoading) CircularProgressIndicator(),
              AnimatedOpacity(
                opacity: result.isEmpty ? 0.0 : 1.0,
                duration: Duration(milliseconds: 400),
                child: GestureDetector(
                  onTap: copyResult,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      result,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: result.startsWith('✅')
                              ? Colors.green
                              : Colors.red),
                    ),
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
