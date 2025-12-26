import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _biometricAuth = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildSectionHeader("Security"),
          SwitchListTile(
            title: const Text("Biometric Unlock"),
            subtitle: const Text("Use FaceID/Fingerprint to open Vault"),
            value: _biometricAuth,
            activeColor: Colors.redAccent,
            onChanged: (val) => setState(() => _biometricAuth = val),
          ),
          
          _buildSectionHeader("Notifications"),
          SwitchListTile(
            title: const Text("Daily Security Tips"),
            subtitle: const Text("Receive daily advice on staying safe"),
            value: _notificationsEnabled,
            activeColor: Colors.redAccent,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
          ),
          
          _buildSectionHeader("Data"),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text("Wipe All Data"),
            onTap: () {
              // TODO: Implement wipe logic
            },
          ),
          
          const Divider(),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Version 1.0.0", style: TextStyle(color: Colors.grey)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}