import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  @override
  _PasswordGeneratorScreenState createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  String password = '';
  double length = 12;
  bool _isGenerating = false;
  bool _isCopying = false;

  final String chars =
      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()-_=+";

  void updatePassword() {
    final rand = Random.secure();
    String newPassword = List.generate(length.toInt(),
            (index) => chars[rand.nextInt(chars.length)])
        .join();
    setState(() {
      password = newPassword;
    });
  }

  void copyToClipboard() {
    if (password.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: password));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Generator'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Password Generator',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: copyToClipboard,
                child: AnimatedOpacity(
                  opacity: password.isEmpty ? 0.6 : 1.0,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      password.isEmpty
                          ? 'Generated password will appear here'
                          : password,
                      style: TextStyle(fontSize: 18, color: Colors.lightBlue),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Length: ${length.toInt()}'),
                  Expanded(
                    child: Slider(
                      min: 6,
                      max: 32,
                      divisions: 26,
                      value: length,
                      label: '${length.toInt()}',
                      onChanged: (val) => setState(() => length = val),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    scale: _isGenerating ? 0.95 : 1.0,
                    duration: Duration(milliseconds: 100),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        setState(() => _isGenerating = true);
                        updatePassword();
                        await Future.delayed(Duration(milliseconds: 100));
                        setState(() => _isGenerating = false);
                      },
                      icon: Icon(Icons.refresh),
                      label: Text('Generate'),
                    ),
                  ),
                  SizedBox(width: 12),
                  AnimatedScale(
                    scale: _isCopying ? 0.95 : 1.0,
                    duration: Duration(milliseconds: 100),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        setState(() => _isCopying = true);
                        copyToClipboard();
                        await Future.delayed(Duration(milliseconds: 100));
                        setState(() => _isCopying = false);
                      },
                      icon: Icon(Icons.copy),
                      label: Text('Copy'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
