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
    return Stack(alignment: Alignment.center, children: <Widget>[
      _image == null
          ? const Text('No image selected.')
          // the image is a file so we need to give it the file path
          : Image.file(File(_image!.path)),
      Align(
          //alignment: Alignment.bottomRight,
          child: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return modalSheet(context);
                    });
              },
              tooltip: 'Pick Image',
              child: const Icon(Icons.add_a_photo)))
    ]);
  }

  Widget modalSheet(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text('Camera'),
          onTap: () {
            Navigator.pop(context);
            _getImage(ImageSource.camera);
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text('Gallery'),
          onTap: () {
            Navigator.pop(context);
            _getImage(ImageSource.gallery);
          },
        ),
        const Padding(padding: EdgeInsets.all(15)),
      ],
    );
  }

  // This function is used to get the image from the camera
  Future _getImage(ImageSource source) async {
    // Future is used with async
    // pickImage has two sources for ImageSource: .camera and .gallery

    // need to make an action sheet or popup to choose between camera and gallery

    final XFile? image;

    if (source == ImageSource.camera) {
      image = await _picker.pickImage(source: ImageSource.camera);
    } else {
      image = await _picker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _image = image; // set the image to the image file
    });
  }
}
