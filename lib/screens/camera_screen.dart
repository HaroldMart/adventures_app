import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  List<File> _savedImages = [];

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final appDir = await getExternalStorageDirectory();
      final imagesDir = Directory('${appDir!.path}/AdventuresApp');
      if (!imagesDir.existsSync()) {
        imagesDir.createSync();
      }
      final newImage = File(image.path);
      final savedImage = await newImage.copy('${imagesDir.path}/${DateTime.now().toIso8601String()}.jpg');
      setState(() {
        _savedImages.add(savedImage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto, 
        child: const Icon(IconlyBold.camera)
      ),
      body: Center(child: _savedImages.isEmpty 
      ? const Text('No hay imagenes, ¡agrega algunas!',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700
        ),
      ) 
      : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: _savedImages.length,
                itemBuilder: (context, index) {
                  final imageFile = _savedImages[index];
                  return Image.file(imageFile, fit: BoxFit.cover);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
