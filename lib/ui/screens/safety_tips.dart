import 'package:flutter/material.dart';

class SafetyTipsScreen extends StatelessWidget {
  const SafetyTipsScreen({super.key});

  final List<Map<String, String>> tips = const [
    {
      "title": "Use Strong Passwords",
      "body": "A strong password is at least 12 characters long and includes a mix of uppercase letters, lowercase letters, numbers, and symbols. Avoid using common words or personal info."
    },
    {
      "title": "Enable 2FA Everywhere",
      "body": "Two-Factor Authentication (2FA) adds a second layer of security. Even if a hacker gets your password, they can't log in without the code from your phone."
    },
    {
      "title": "Beware of Phishing",
      "body": "Never click links in emails or texts from unknown senders. attackers often pretend to be your bank or Netflix to steal your credentials."
    },
    {
      "title": "Keep Software Updated",
      "body": "Software updates often contain security patches. Delaying updates leaves your device vulnerable to known exploits."
    },
    {
      "title": "Avoid Public Wi-Fi",
      "body": "Public Wi-Fi networks are often unsecured. Hackers can intercept data sent over them. Use a VPN if you must connect."
    },
     {
      "title": "Check App Permissions",
      "body": "Does that flashlight app really need access to your contacts and location? Review permissions regularly in your phone settings."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Colors.redAccent.withOpacity(0.1),
                child: const Icon(Icons.shield_outlined, color: Colors.redAccent),
              ),
              title: Text(
                tips[index]["title"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    tips[index]["body"]!,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}