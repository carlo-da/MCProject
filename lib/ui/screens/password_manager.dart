import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

// 1. DATA MODEL
class PasswordEntry {
  String id;
  String title;
  String username;
  String password;
  int colorValue; // Store color as an integer

  PasswordEntry({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    required this.colorValue,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'username': username,
        'password': password,
        'colorValue': colorValue,
      };

  factory PasswordEntry.fromJson(Map<String, dynamic> json) {
    return PasswordEntry(
      id: json['id'],
      title: json['title'],
      username: json['username'],
      password: json['password'],
      colorValue: json['colorValue'],
    );
  }
}

class PasswordManager extends StatefulWidget {
  const PasswordManager({super.key});

  @override
  State<PasswordManager> createState() => _PasswordManagerState();
}

class _PasswordManagerState extends State<PasswordManager> {
  final _storage = const FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();
  List<PasswordEntry> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  // LOAD DATA
  Future<void> _loadEntries() async {
    final String? data = await _storage.read(key: 'password_vault_data');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      if (mounted) {
        setState(() {
          _entries = jsonList.map((e) => PasswordEntry.fromJson(e)).toList();
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _entries = [];
          _isLoading = false;
        });
      }
    }
  }

  // SAVE DATA
  Future<void> _saveEntries() async {
    final String data = jsonEncode(_entries.map((e) => e.toJson()).toList());
    await _storage.write(key: 'password_vault_data', value: data);
  }

  // UPDATED BIOMETRIC CHECK (Fixes Windows/Emulator issue)
  Future<bool> _authenticate() async {
    // 1. Check if hardware is available
    final bool canCheckBiometrics = await auth.canCheckBiometrics;
    final bool isDeviceSupported = await auth.isDeviceSupported();

    // If device doesn't support it (e.g. Windows PC without Hello), allow access for testing
    if (!canCheckBiometrics || !isDeviceSupported) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Biometrics not available on this device. Opening for testing...")));
      }
      return true; // Bypass security for testing
    }

    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to view password',
        options: const AuthenticationOptions(
          biometricOnly: false, // Allows PIN/Pattern backup
          stickyAuth: true,
        ),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      debugPrint("Auth Error: $e");
      return false;
    }
  }

  // SHOW PASSWORD DIALOG
  void _showDetails(PasswordEntry entry) async {
    bool isAuthorized = await _authenticate();

    if (isAuthorized && mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(entry.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Username:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(entry.username, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              const Text("Password:", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                      child: Text(entry.password,
                          style: const TextStyle(fontSize: 16, fontFamily: 'monospace'))),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: entry.password));
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Password Copied!")));
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
                child: const Text("Close"), onPressed: () => Navigator.pop(context)),
          ],
        ),
      );
    }
  }

  // ADD / EDIT DIALOG
  void _showEntryDialog({PasswordEntry? entry}) {
    final titleController = TextEditingController(text: entry?.title ?? '');
    final userController = TextEditingController(text: entry?.username ?? '');
    final passController = TextEditingController(text: entry?.password ?? '');
    
    // Default to Red to match theme, unless editing an existing card
    Color selectedColor = entry != null ? Color(entry.colorValue) : Colors.redAccent;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(entry == null ? "Add Account" : "Edit Account"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Service Name (e.g. Facebook)")),
                  TextField(
                      controller: userController,
                      decoration: const InputDecoration(labelText: "Username / Email")),
                  TextField(
                      controller: passController,
                      decoration: const InputDecoration(labelText: "Password")),
                  const SizedBox(height: 15),
                  const Text("Card Color"),
                  const SizedBox(height: 10),
                  // Color Picker Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _colorOption(Colors.redAccent, selectedColor,
                          () => setStateDialog(() => selectedColor = Colors.redAccent)),
                      _colorOption(Colors.blue, selectedColor,
                          () => setStateDialog(() => selectedColor = Colors.blue)),
                      _colorOption(Colors.amber, selectedColor,
                          () => setStateDialog(() => selectedColor = Colors.amber)),
                      _colorOption(Colors.green, selectedColor,
                          () => setStateDialog(() => selectedColor = Colors.green)),
                      _colorOption(Colors.purple, selectedColor,
                          () => setStateDialog(() => selectedColor = Colors.purple)),
                    ],
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  child: const Text("Cancel"), onPressed: () => Navigator.pop(context)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                child: const Text("Save"),
                onPressed: () {
                  setState(() {
                    if (entry == null) {
                      // Add New
                      _entries.add(PasswordEntry(
                        id: DateTime.now().toString(),
                        title: titleController.text,
                        username: userController.text,
                        password: passController.text,
                        colorValue: selectedColor.value,
                      ));
                    } else {
                      // Update Existing
                      entry.title = titleController.text;
                      entry.username = userController.text;
                      entry.password = passController.text;
                      entry.colorValue = selectedColor.value;
                    }
                    _saveEntries();
                  });
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      ),
    );
  }

  Widget _colorOption(Color color, Color selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: color,
        radius: 15,
        child: selected.value == color.value
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      backgroundColor: Colors.white,
      // No App bar needed here because MainScreen provides the header/tabs
      body: _entries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text("No passwords saved yet.", style: TextStyle(color: Colors.grey)),
                  const Text("Tap + to add one.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final item = _entries[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      // TRASH CAN (Left)
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.grey),
                        onPressed: () async {
                          bool confirm = await showDialog(
                                  context: context,
                                  builder: (c) => AlertDialog(
                                        title: const Text("Delete?"),
                                        actions: [
                                          TextButton(
                                              child: const Text("No"),
                                              onPressed: () => Navigator.pop(c, false)),
                                          TextButton(
                                              child: const Text("Yes", style: TextStyle(color: Colors.red)),
                                              onPressed: () => Navigator.pop(c, true))
                                        ],
                                      )) ??
                              false;

                          if (confirm) {
                            setState(() {
                              _entries.removeAt(index);
                              _saveEntries();
                            });
                          }
                        },
                      ),

                      // THE CARD (Middle)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showDetails(item), // Triggers Biometrics
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: Color(item.colorValue),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2))
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  item.username,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // PEN (Right)
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                        onPressed: () => _showEntryDialog(entry: item),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showEntryDialog(),
      ),
    );
  }
}