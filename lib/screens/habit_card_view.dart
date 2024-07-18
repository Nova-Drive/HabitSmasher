import 'package:flutter/material.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/theme.dart';

class HabitCardView extends StatelessWidget {
  final Habit habit;

  const HabitCardView({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    bool longDescription = habit.description.length > 40;
    return Card(
      color: theme.cardTheme.color,
      surfaceTintColor: theme.cardTheme.surfaceTintColor,
      shadowColor: theme.cardTheme.shadowColor,
      elevation: theme.cardTheme.elevation,
      child: ListTile(
        title: Text(
          habit.name,
        ),
        subtitle: Text(longDescription
            ? '${habit.description.substring(0, 40)}...'
            : habit.description),
        trailing: Text(habit.daysToString()),
      ),
    );
  }
}
