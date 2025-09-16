import 'package:flutter/material.dart';
import 'widgets/custom_header.dart';

class PasswordCheckerScreen extends StatefulWidget {
  const PasswordCheckerScreen({super.key});

  @override
  _PasswordCheckerScreenState createState() => _PasswordCheckerScreenState();
}

class _PasswordCheckerScreenState extends State<PasswordCheckerScreen> {
  final TextEditingController _controller = TextEditingController();
  Color _borderColor = Colors.grey;

  Color _getStrengthColor(String password) {
    if (password.isEmpty) return Colors.grey;
    if (password.length < 6) return Colors.red;
    if (password.length < 10) return Colors.orange;
    if (password.length < 14) return Colors.yellow[700]!;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomHeader(title: "Password Strength Checker"), // ✅ new header
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
                        onChanged: (value) {
                          setState(() {
                            _borderColor = _getStrengthColor(value);
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter your password",
                          hintStyle: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Password strength is shown by the border color.",
                      style: TextStyle(color: Colors.black87),
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
