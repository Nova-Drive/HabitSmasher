import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/models/habit_event.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

GoogleSignIn _googleSignIn = GoogleSignIn();
FirebaseAuth _auth = FirebaseAuth.instance;

Future<List<HabitEvent>> getHabitEvents(Habit habit) async {
  List<HabitEvent> habitEvents = [];
  FirebaseFirestore db = FirebaseFirestore.instance;

  // wait .2 seconds just in case event is edited and we need to wait for the db to update
  await Future.delayed(const Duration(milliseconds: 250));

  QuerySnapshot querySnapshot = await db
      .collection("users")
      .doc(_auth.currentUser!.uid)
      .collection('habits')
      .where('id', isEqualTo: habit.id)
      .get();
  String habitId = querySnapshot.docs[0].id;

  QuerySnapshot eventQuerySnapshot = await db
      .collection("users")
      .doc(_auth.currentUser!.uid)
      .collection('habits')
      .doc(habitId)
      .collection('events')
      .get();

  for (var doc in eventQuerySnapshot.docs) {
    habitEvents
        .add(HabitEvent.fromMap(doc.data() as Map<String, dynamic>, habit));
  }

  return habitEvents;
}

Future<List<Habit>> getHabits() async {
  List<Habit> habits = [];
  FirebaseFirestore db = FirebaseFirestore.instance;

  QuerySnapshot querySnapshot = await db
      .collection("users")
      .doc(_auth.currentUser!.uid)
      .collection('habits')
      .get();

  for (var doc in querySnapshot.docs) {
    habits.add(Habit.fromMap(doc.data() as Map<String, dynamic>));
  }

  return habits;
}

Future<String> uploadPic(File image, String habitId) async {
  String randomId = const Uuid().v4();
  FirebaseStorage storage = FirebaseStorage.instance;

  // habit id is not the same as the one in the db im pretty sure
  Reference reference =
      storage.ref().child("images/${_auth.currentUser!.uid}/$randomId");

  //Upload the file to firebase
  UploadTask uploadTask = reference.putFile(image);

  String url = '';

  uploadTask.whenComplete(() async {
    url = await reference.getDownloadURL();
  });

  while (url == '') {
    debugPrint('waiting for url');
    await Future.delayed(const Duration(milliseconds: 100));
  }
  debugPrint(url);
  return url;
}

void deletePic(String url) {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference reference = storage.refFromURL(url);
  reference.delete();
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await _auth.signInWithCredential(credential);
}

Future<void> signOut() async {
  await _auth.signOut();
  await _googleSignIn.signOut();
  debugPrint(FirebaseAuth.instance.currentUser.toString());
}
