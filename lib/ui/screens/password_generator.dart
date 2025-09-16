import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ for clipboard
import 'widgets/custom_header.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  _PasswordGeneratorScreenState createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  String _generatedPassword = "";
  double _length = 16; // default length

  String _generatePassword(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%^&*()';
    Random rnd = Random();
    return List.generate(length, (index) => chars[rnd.nextInt(chars.length)])
        .join();
  }

  void _onGenerate() {
    setState(() {
      _generatedPassword = _generatePassword(_length.toInt());
    });
  }

  void _copyToClipboard() {
    if (_generatedPassword.isEmpty) return;
    Clipboard.setData(ClipboardData(text: _generatedPassword));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Password copied to clipboard!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomHeader(title: "Password Generator"),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Length slider
                    Column(
                      children: [
                        Text(
                          "Password length: ${_length.toInt()}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Slider(
                          value: _length,
                          min: 6,
                          max: 32,
                          divisions: 26,
                          label: _length.toInt().toString(),
                          activeColor: Colors.lightBlue,
                          onChanged: (value) {
                            setState(() {
                              _length = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Generate button
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
                      onPressed: _onGenerate,
                      child: const Text("Generate Password"),
                    ),

                    const SizedBox(height: 20),

                    // Generated password
                    SelectableText(
                      _generatedPassword.isEmpty
                          ? "Use the slider and button to generate a password"
                          : _generatedPassword,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    // Copy to clipboard button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _copyToClipboard,
                      icon: const Icon(Icons.copy),
                      label: const Text("Copy to Clipboard"),
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
