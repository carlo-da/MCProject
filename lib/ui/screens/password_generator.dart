import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordGenerator extends StatefulWidget {
  const PasswordGenerator({super.key});

  @override
  State<PasswordGenerator> createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends State<PasswordGenerator>
    with SingleTickerProviderStateMixin {
  
  // State for Password Options
  String _generatedPassword = "";
  double _passwordLength = 12;
  bool _useUppercase = true;
  bool _useNumbers = true;
  bool _useSymbols = true;

  // Animations
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    // Initialize Animation
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _scaleAnim = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    // Generate initial password
    _generatePassword();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _generatePassword() {
    const letters = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()_+';
    const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    String chars = letters;
    if (_useUppercase) chars += upper;
    if (_useNumbers) chars += numbers;
    if (_useSymbols) chars += symbols;

    final rand = Random.secure();
    final pass = List.generate(
        _passwordLength.toInt(), (index) => chars[rand.nextInt(chars.length)]);

    setState(() {
      _generatedPassword = pass.join();
    });

    // Reset and run animation
    _animController.forward(from: 0);
  }

  void _copyToClipboard() {
    if (_generatedPassword.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _generatedPassword));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Copied to clipboard!"),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent, // Changed to Red
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Password Generator",
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent // Red Header
                ),
              ),
            ),
            
            // Main Content
            Expanded(
              child: ListView( // Changed to ListView for scrolling on small screens
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const Text(
                    "Create strong, secure passwords instantly.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 30),

                  // 1. THE PASSWORD DISPLAY
                  Center(
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: ScaleTransition(
                        scale: _scaleAnim,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[300]!)
                          ),
                          child: Column(
                            children: [
                              SelectableText(
                                _generatedPassword,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontFamily: 'monospace',
                                  color: Colors.black87
                                ),
                              ),
                              const SizedBox(height: 10),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 26, color: Colors.redAccent), // Red Icon
                                onPressed: _copyToClipboard,
                                tooltip: "Copy password",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 2. CONTROLS
                  Text("Length: ${_passwordLength.toInt()}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: _passwordLength,
                    min: 6,
                    max: 32,
                    divisions: 26,
                    label: _passwordLength.toInt().toString(),
                    activeColor: Colors.redAccent, // Red Slider
                    inactiveColor: Colors.redAccent.withOpacity(0.2),
                    onChanged: (val) {
                      setState(() {
                        _passwordLength = val;
                      });
                      _generatePassword(); // Auto-update when sliding
                    },
                  ),

                  const SizedBox(height: 10),

                  // 3. OPTIONS TOGGLES
                  _buildSwitch("Use Uppercase (A-Z)", _useUppercase, (v) => setState(() => _useUppercase = v)),
                  _buildSwitch("Use Numbers (0-9)", _useNumbers, (v) => setState(() => _useNumbers = v)),
                  _buildSwitch("Use Symbols (!@#)", _useSymbols, (v) => setState(() => _useSymbols = v)),

                  const SizedBox(height: 30),

                  // 4. GENERATE BUTTON
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _generatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent, // Red Button
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text("GENERATE NEW", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(String title, bool val, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: val,
      activeColor: Colors.redAccent, // Red Switch
      contentPadding: EdgeInsets.zero,
      onChanged: (v) {
        onChanged(v);
        _generatePassword(); // Auto-update on toggle
      },
    );
  }
}