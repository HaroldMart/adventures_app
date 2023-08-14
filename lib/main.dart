import 'package:firebase_core/firebase_core.dart';
import 'screens/signin_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adventures App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const SignInScreen(),
    );
  }
}