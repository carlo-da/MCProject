import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/custom_header.dart';

class PasswordChecker extends StatefulWidget {
  const PasswordChecker({super.key});

  @override
  State<PasswordChecker> createState() => _PasswordCheckerState();
}

class _PasswordCheckerState extends State<PasswordChecker>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String _feedback = "";
  Color _glowColor = Colors.grey;

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _controller.addListener(_updateStrengthLive);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateStrengthLive);
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  int _calculateStrength(String password) {
    if (password.isEmpty) return 0;

    int strength = 0;
    if (password.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;

    return strength;
  }

  void _updateStrengthLive() {
    final password = _controller.text;
    final strength = _calculateStrength(password);

    setState(() {
      switch (strength) {
        case 0:
          _feedback = "";
          _glowColor = Colors.grey;
          break;
        case 1:
          _feedback = "Weak password";
          _glowColor = Colors.red;
          break;
        case 2:
          _feedback = "Moderate password";
          _glowColor = Colors.orange;
          break;
        case 3:
          _feedback = "Strong password";
          _glowColor = Colors.yellow.shade700;
          break;
        case 4:
          _feedback = "Very strong password";
          _glowColor = Colors.green;
          break;
        default:
          _feedback = "";
          _glowColor = Colors.grey;
      }
    });

    _animController.forward(from: 0);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomHeader(title: "Password Checker"),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              "Check how strong your password is. "
              "A good password is long, includes uppercase, lowercase, numbers, and symbols.",
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
                            color: _glowColor.withOpacity(0.6),
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
                      onPressed: _updateStrengthLive,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Check Strength"),
                    ),
                    const SizedBox(height: 16),
                    if (_feedback.isNotEmpty)
                      FadeTransition(
                        opacity: _animController,
                        child: Text(
                          _feedback,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _glowColor,
                          ),
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
