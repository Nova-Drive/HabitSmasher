import 'package:flutter/material.dart';
import 'package:habitsmasher/models/habit.dart';

class HabitCardView extends StatelessWidget {
  final Habit habit;

  const HabitCardView({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Colors.amber,
      child: ListTile(
        title: Text(habit.name),
        subtitle: Text(habit.description),
        trailing: Text(habit.daysToString()),
      ),
    );
  }
}
