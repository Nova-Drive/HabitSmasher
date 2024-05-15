import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:habitsmasher/extensions.dart';

class HabitEvent {
  String id;
  Habit habit;
  String comment;
  DateTime date;
  LocationData? location;
  String? imagePath;

  HabitEvent({
    required this.comment,
    required this.date,
    required this.habit,
    this.location,
    this.imagePath,
    String? id,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'comment': comment,
      'date': date,
      'habitId': habit.id,
      'location': location?.toJson(),
      //'imagePath': imagePath,
    };
  }

  factory HabitEvent.fromMap(Map<String, dynamic> map, Habit habit) {
    return HabitEvent(
      id: map['id'],
      comment: map['comment'],
      date: (map['date'] as Timestamp).toDate(),
      habit: habit,
      location: map['location'] != null
          ? LocationData.fromMap(map['location'])
          : null,
      //imagePath: map['imagePath'],
    );
  }
}
