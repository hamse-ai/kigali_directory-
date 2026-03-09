import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Verified User'),
            accountEmail: Text(user?.email ?? 'No email'),
            currentAccountPicture: const CircleAvatar(child: Icon(Icons.person)),
          ),
          SwitchListTile(
            title: const Text('Location Notifications'),
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          // Change this section in your settings_screen.dart
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () { // Changed from onPressed to onTap
              context.read<AuthService>().signOut();
            },
          ),
        ],
      ),
    );
  }
}