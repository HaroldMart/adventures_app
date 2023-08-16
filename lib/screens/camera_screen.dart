import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_screen.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ImagePicker _picker = ImagePicker();
  List<File> _savedImages = [];

  final Logger _logger = Logger();
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final appDir = await getExternalStorageDirectory();
      final imagesDir = Directory('${appDir!.path}/AdventuresApp');
      if (!imagesDir.existsSync()) {
        imagesDir.createSync();
      }
      final newImage = File(image.path);
      final savedImage = await newImage
          .copy('${imagesDir.path}/${DateTime.now().toIso8601String()}.jpg');
      setState(() {
        _savedImages.add(savedImage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: _takePhoto, child: const Icon(IconlyBold.camera)),
      body: Column(
        children: [
          Column(
            children: [
              Text(
                'Correo actual: ${user?.email ?? "Ningún usuario en sesión"}',
                style: const TextStyle(fontSize: 18),
              ),
              ElevatedButton(
                child: const Text('Cerrar Sesión'),
                onPressed: () async {
                  await GoogleSignIn().signOut();
                  FirebaseAuth.instance.signOut().then((value) {
                    _logger.i('Cerrar Sesión');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                    );
                  });
                },
              ),
            ],
          ),
          _savedImages.isEmpty
              ? const Text(
                  'No hay imagenes, ¡agrega algunas!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                )
              : SingleChildScrollView(
                  child: Expanded(
                    child: SizedBox(
                      height: 580,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: _savedImages.length,
                        itemBuilder: (context, index) {
                          final imageFile = _savedImages[index];
                          return Image.file(imageFile, fit: BoxFit.cover);
                        },
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
