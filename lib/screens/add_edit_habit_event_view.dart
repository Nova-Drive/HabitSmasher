import 'dart:async';
import 'dart:io';
import 'package:blur/blur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habitsmasher/widgets/date_picker.dart';
import 'package:habitsmasher/extensions.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/models/habit_event.dart';
import 'package:habitsmasher/network/network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AddEditHabitEventView extends StatefulWidget {
  final Function? addHabitEvent;
  final Function? editHabitEvent;
  final HabitEvent? habitEvent;
  final Habit habit;

  const AddEditHabitEventView(
      {super.key,
      required this.habit,
      this.addHabitEvent,
      this.editHabitEvent,
      this.habitEvent});

  @override
  State<AddEditHabitEventView> createState() => _AddEditHabitEventViewState();
}

class _AddEditHabitEventViewState extends State<AddEditHabitEventView> {
  Operation? operation;
  TextEditingController commentController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime date = DateTime.now();
  bool? addLocation = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  bool _isUploading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    if (widget.habitEvent != null && widget.editHabitEvent != null) {
      operation = Operation.edit;
      // set the values of the form fields to the values of the habit event
      commentController.text = widget.habitEvent!.comment;
      date = widget.habitEvent!.date;
      dateController.text = date.toString().substring(0, 10);
      if (widget.habitEvent!.location != null) {
        addLocation = true;
      }
    } else if (widget.addHabitEvent != null) {
      operation = Operation.add;
    } else {
      // throw an error
      throw Exception(
          'Invalid function call. Must provide either add or edit function.');
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<LocationData> locationService() async {
    Location location = Location();
    await Future.wait(
        [location.requestPermission(), location.requestService()]);
    // await location.requestService();

    LocationData place =
        await Future.wait([location.getLocation()]).then((value) => value[0]);

    return place;
  }

  void _validate() {
    if (commentController.text.isEmpty) {
      throw NoCommentException('Comment cannot be empty.');
    } else if (date.isAfter(DateTime.now())) {
      throw FutureDateException('Date cannot be in the future.');
    }
  }

  void _onSubmit() async {
    try {
      _validate();
    } on Exception catch (e) {
      showException(context, e);
      return;
    }
    setState(() {
      _isUploading = true;
    });

    HabitEvent event = HabitEvent(
        comment: commentController.text, date: date, habit: widget.habit);

    if (addLocation!) {
      debugPrint('Adding location');

      locationService().then((place) => event.location = place);

      while (event.location == null) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      // locationService().then((LocationData place) {
      //   event.location = place;
      // });
    }

    //picture stuff goes here
    if (_image != null) {
      uploadPic(File(_image!.path), widget.habit.id)
          .then((url) => event.imagePath = url);
      while (event.imagePath == null) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    if (operation == Operation.edit) {
      _editHabitEvent(widget.habitEvent!, event);
      Navigator.pop(context);
      return;
    } else if (operation == Operation.add) {
      _addHabitEvent(event);
      Navigator.pop(context);
      return;
    } else {
      throw Exception('Invalid operation when submitting form.');
    }
  }

  void _addHabitEvent(HabitEvent event) async {
    widget.addHabitEvent!(event);
    db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("habits")
        .where("id", isEqualTo: widget.habit.id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("habits")
          .doc(querySnapshot.docs[0].id)
          .collection("events")
          .add(event.toMap());
    });
  }

  void _editHabitEvent(HabitEvent oldEvent, HabitEvent newEvent) async {
    newEvent.imagePath ??= oldEvent.imagePath;
    newEvent.location ??= oldEvent.location;

    widget.editHabitEvent!(oldEvent);
    String oldHabitId = "";

    db
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("habits")
        .where("id", isEqualTo: widget.habit.id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      oldHabitId = querySnapshot.docs[0].id;
      db
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("habits")
          .doc(oldHabitId)
          .collection("events")
          .where("id", isEqualTo: oldEvent.id)
          .get()
          .then((QuerySnapshot querySnapshot) {
        db
            .collection("users")
            .doc(auth.currentUser!.uid)
            .collection("habits")
            .doc(oldHabitId)
            .collection("events")
            .doc(querySnapshot.docs[0].id)
            .update(newEvent.toMap());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(operation == Operation.add
            ? 'Add Habit Event'
            : 'Edit Habit Event'),
      ),
      body: GestureDetector(
        // when the user taps outside of the text field
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Stack(alignment: Alignment.center, children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    TextField(
                      minLines: 3,
                      maxLines: null,
                      controller: commentController,
                      cursorColor: Colors.brown,
                      decoration: inputDecoration(labelText: "Comment"),
                    ),
                    const Padding(padding: EdgeInsets.all(7)),
                    DatePicker(
                        startDateController: dateController,
                        setDate: (date) {
                          setState(() {
                            this.date = date;
                            dateController.text =
                                date.toString().substring(0, 10);
                          });
                        }),
                    Row(children: [
                      const Text('Add current location?'),
                      Checkbox(
                          value: addLocation,
                          onChanged: (bool? value) => setState(() {
                                addLocation = value!;
                              }))
                    ]),
                    Row(children: [
                      const Text("Add picture?"),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15)),
                      ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return modalSheet(context);
                                });
                          },
                          child: const Text('Add Picture'))
                    ]),
                    if (_image != null)
                      BorderBox(child: Image.file(File(_image!.path))),
                    const Padding(padding: EdgeInsets.all(15)),
                    ElevatedButton(
                        onPressed: _onSubmit, child: const Text('Add Event')),
                    const Padding(padding: EdgeInsets.only(bottom: 20))
                  ],
                ),
              ),
              if (_isUploading)
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ).blurred(
                    overlay: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.green)))
            ]),
          ),
        ),
      ),
    );
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

class NoCommentException implements Exception {
  final String message;

  @override
  String toString() {
    return message;
  }

  NoCommentException(this.message);
}

class FutureDateException implements Exception {
  final String message;

  @override
  String toString() {
    return message;
  }

  FutureDateException(this.message);
}
