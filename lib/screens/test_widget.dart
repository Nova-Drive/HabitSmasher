import 'dart:io';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  //final List<HabitEvent> habitEvents = sampleHabitEvents;

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Comments are here to help understand processes

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();

  XFile? _image; // XFile is the type of the image file

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example of Image Picker in flutter'),
      ),
      body: Center(
        child: _image == null
            ? const Text('No image selected.')
            // the image is a file so we need to give it the file path
            : Image.file(File(_image!.path)), // get the image file via path
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  // This function is used to get the image from the camera
  Future getImage() async {
    // Future is used with async
    // pickImage has two sources for ImageSource: .camera and .gallery
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image; // set the image to the image file
    });
  }
}
