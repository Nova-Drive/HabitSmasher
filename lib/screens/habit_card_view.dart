import 'package:flutter/material.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/theme.dart';

class HabitCardView extends StatelessWidget {
  final Habit habit;

  const HabitCardView({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.cardTheme.color,
      surfaceTintColor: theme.cardTheme.surfaceTintColor,
      shadowColor: theme.cardTheme.shadowColor,
      elevation: theme.cardTheme.elevation,
      child: ListTile(
        title: Text(habit.name),
        subtitle: Text(habit.description),
        trailing: Text(habit.daysToString()),
      ),
    );
  }
}
