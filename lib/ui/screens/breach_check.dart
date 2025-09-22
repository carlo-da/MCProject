import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/custom_header.dart';

class BreachChecker extends StatefulWidget {
  const BreachChecker({super.key});

  @override
  State<BreachChecker> createState() => _BreachCheckerState();
}

class _BreachCheckerState extends State<BreachChecker> {
  final TextEditingController _controller = TextEditingController();
  bool? _breached;

  void _checkBreach() {
    // Placeholder logic: mark as breached if password length < 8
    setState(() {
      _breached = _controller.text.length < 8 ? true : false;
    });
  }

  void _copyToClipboard() {
    if (_controller.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _controller.text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Password copied!"),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Color _getGlowColor() {
    if (_breached == null) return Colors.grey;
    return _breached! ? Colors.red : Colors.green;
  }

  String _getFeedback() {
    if (_breached == null) return "";
    return _breached! ? "Password has been breached!" : "Password is safe!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomHeader(title: "Breach Checker"),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "Check if your password has appeared in known data breaches.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _getGlowColor().withOpacity(0.6),
                            blurRadius: 16,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter your password",
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _checkBreach,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Check Breach"),
                    ),
                    const SizedBox(height: 16),
                    if (_breached != null)
                      Text(
                        _getFeedback(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getGlowColor(),
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.copy,
                            size: 28, color: Colors.blueAccent),
                        onPressed: _copyToClipboard,
                        tooltip: "Copy password",
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
