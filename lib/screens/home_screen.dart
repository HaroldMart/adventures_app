import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_screen.dart';
import 'package:logger/logger.dart';
import 'package:adventures_app/screens/map_screen.dart';
import  "package:adventures_app/screens/settings_screen.dart";
import 'package:adventures_app/screens/places_screen.dart';

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
    HomeContent(),
    MapScreen(),
    Places(),
    SettingsContent(),
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
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false
      ),
      body: Center(
        child: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map, color: Colors.black,),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place, color: Colors.black,),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.black,),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
   User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [ 
          Text('Correo actual: ${user?.email ?? "Ningún usuario en sesión"}',style: const TextStyle(fontSize: 18),),
          const Text("Home content")
          ],)
    );
  }
}
