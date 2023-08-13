import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:adventures_app/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsContent extends StatelessWidget {
   final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('Logout'),
        onPressed: () {
          FirebaseAuth.instance.signOut().then((value) {
            _logger.i('Signed Out');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          });
        },
      ),
    );
  }
}