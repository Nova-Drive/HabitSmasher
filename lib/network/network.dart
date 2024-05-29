import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/models/habit_event.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<List<HabitEvent>> getHabitEvents(Habit habit) async {
  List<HabitEvent> habitEvents = [];
  FirebaseFirestore db = FirebaseFirestore.instance;

  // wait .2 seconds just in case event is edited and we need to wait for the db to update
  await Future.delayed(const Duration(milliseconds: 250));

  QuerySnapshot querySnapshot =
      await db.collection('habits').where('id', isEqualTo: habit.id).get();
  String habitId = querySnapshot.docs[0].id;

  QuerySnapshot eventQuerySnapshot =
      await db.collection('habits').doc(habitId).collection('events').get();

  for (var doc in eventQuerySnapshot.docs) {
    habitEvents
        .add(HabitEvent.fromMap(doc.data() as Map<String, dynamic>, habit));
  }

  return habitEvents;
}

Future<List<Habit>> getHabits() async {
  List<Habit> habits = [];
  FirebaseFirestore db = FirebaseFirestore.instance;

  QuerySnapshot querySnapshot = await db.collection('habits').get();

  for (var doc in querySnapshot.docs) {
    habits.add(Habit.fromMap(doc.data() as Map<String, dynamic>));
  }

  return habits;
}

String uploadPic(File image) {
  FirebaseStorage storage = FirebaseStorage.instance;
  //Create a reference to the location you want to upload to in firebase
  Reference reference = storage.ref().child("images/test");

  //Upload the file to firebase
  UploadTask uploadTask = reference.putFile(image);

  String url = ' ';
  uploadTask.whenComplete(() async => url = await reference.getDownloadURL());

  //returns the download url
  return url;
}
