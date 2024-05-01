import 'package:habitsmasher/models/habit.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

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
  }) : id = const Uuid().v4();
}
