import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BreachChecker extends StatefulWidget {
  const BreachChecker({super.key});

  @override
  State<BreachChecker> createState() => _BreachCheckerState();
}

class _BreachCheckerState extends State<BreachChecker> {
  final TextEditingController _controller = TextEditingController();
  bool? _breached;

  // Simulate a check (In a real app, this would hit an API like HaveIBeenPwned)
  void _checkBreach() {
    setState(() {
      // Placeholder: Logic simulates a breach if password is common or short
      _breached = _controller.text.length < 8; 
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
          backgroundColor: Colors.redAccent, // Red Theme
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  // Visual Feedback Colors
  Color _getGlowColor() {
    if (_breached == null) return Colors.grey;
    return _breached! ? Colors.red : Colors.green;
  }

  String _getFeedback() {
    if (_breached == null) return "";
    return _breached! ? "⚠️ BREACH DETECTED" : "✅ PASSWORD IS SAFE";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Standard Red Header
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Breach Checker",
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent 
                ),
              ),
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Text(
                "Check if your password has appeared in known data breaches.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),

            Expanded(
              child: Center(
                child: SingleChildScrollView( // Added scroll view for small screens
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Input Box
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: _getGlowColor().withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                          border: Border.all(color: _getGlowColor().withOpacity(0.5))
                        ),
                        child: TextField(
                          controller: _controller,
                          obscureText: true,
                          style: const TextStyle(color: Colors.black87),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter password to check...",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.search_off, color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Check Button (Red)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _checkBreach,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent, // Red Theme
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: const Text("CHECK NOW", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Result Text
                      if (_breached != null)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: _getGlowColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getFeedback(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _getGlowColor(),
                              letterSpacing: 1.0
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Copy Button (Red Icon)
                      if (_controller.text.isNotEmpty)
                        TextButton.icon(
                          icon: const Icon(Icons.copy, color: Colors.redAccent),
                          label: const Text("Copy Password", style: TextStyle(color: Colors.redAccent)),
                          onPressed: _copyToClipboard,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}