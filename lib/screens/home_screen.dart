import 'package:adventures_app/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_screen.dart';
import 'package:logger/logger.dart';
import 'package:adventures_app/screens/map_screen.dart';
import 'package:adventures_app/screens/places_screen.dart';
import 'package:iconly/iconly.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Logger _logger = Logger();
  User? user = FirebaseAuth.instance.currentUser;
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    Home(),
    MapScreen(),
    Places(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const SignInScreen(); // Redirige a la pantalla de inicio de sesión si el usuario no está autenticado
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Swifty'), automaticallyImplyLeading: false),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.purple,
        iconSize: 30,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              IconlyLight.home,
              color: Colors.black,
            ),
            activeIcon: Icon(
              IconlyBold.home,
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              IconlyLight.location,
              color: Colors.black,
            ),
            activeIcon: Icon(
              IconlyBold.location,
            ),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              IconlyLight.bag,
              color: Colors.black,
            ),
            activeIcon: Icon(
              IconlyBold.bag,
            ),
            label: 'Local',
          ),
        ],
      ),
    );
  }
}
