import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/models/habit_event.dart';

Future<List<HabitEvent>> getHabitEvents(Habit habit) async {
  List<HabitEvent> habitEvents = [];
  FirebaseFirestore db = FirebaseFirestore.instance;

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
