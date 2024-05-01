import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

enum Days { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class Habit {
  String id;
  String name;
  String description;
  DateTime startDate;
  List<Days> recurranceDays;
  // other things

  Habit(
      {required this.name,
      required this.description,
      required this.startDate,
      required this.recurranceDays,
      String? id})
      : id = id ?? const Uuid().v4();

  daysToString() {
    return recurranceDays.map((day) => day.name.substring(0, 2)).join(', ');
  }

  daysToBool() {
    return [
      recurranceDays.contains(Days.monday),
      recurranceDays.contains(Days.tuesday),
      recurranceDays.contains(Days.wednesday),
      recurranceDays.contains(Days.thursday),
      recurranceDays.contains(Days.friday),
      recurranceDays.contains(Days.saturday),
      recurranceDays.contains(Days.sunday),
    ];
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      startDate: (map['startDate'] as Timestamp).toDate(),
      recurranceDays: (map['recurranceDays'] as List<dynamic>)
          .map((day) => Days.values[day])
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate,
      'recurranceDays': recurranceDays.map((day) => day.index).toList(),
    };
  }
}
