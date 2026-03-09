import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email_outlined, size: 100, color: Colors.blue),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Please verify your email address to access the Kigali Directory.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Reload user to check if they clicked the link
                FirebaseAuth.instance.currentUser?.reload();
              },
              child: const Text('I have verified my email'),
            ),
            TextButton(
              onPressed: () => Provider.of<AuthService>(context, listen: false).signOut(),
              child: const Text('Cancel / Logout'),
            ),
          ],
        ),
      ),
    );
  }
}