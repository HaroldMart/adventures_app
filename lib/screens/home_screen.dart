import 'package:adventures_app/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_screen.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    HomeContent(),
    MapScreen(),
    Places(),
    CameraScreen(),
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
      appBar: AppBar(title: const Text('Home'), automaticallyImplyLeading: false),
      body: Center(
        child: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      )),
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
          BottomNavigationBarItem(
            icon: Icon(
              IconlyLight.image,
              color: Colors.black,
            ),
            activeIcon: Icon(
              IconlyBold.image,
            ),
            label: 'Imagenes',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final Logger _logger = Logger();
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Text(
          'Correo actual: ${user?.email ?? "Ningún usuario en sesión"}',
          style: const TextStyle(fontSize: 18),
        ),
        const Text("Home content"),
        Center(
          child: ElevatedButton(
            child: const Text('Logout'),
            onPressed: () async {
              await GoogleSignIn().signOut();
              FirebaseAuth.instance.signOut().then((value) {
                _logger.i('Signed Out');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              });
            },
          ),
        )
      ],
    ));
  }
}
