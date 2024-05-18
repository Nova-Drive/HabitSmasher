import 'package:flutter/material.dart';
import 'package:habitsmasher/extensions.dart';
import 'package:habitsmasher/models/habit_event.dart';

class HabitEventCard extends StatelessWidget {
  final HabitEvent event;

  const HabitEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    var commentString = event.comment.length > 25
        ? "${event.comment.substring(0, 25)}..."
        : event.comment;

    return Card(
      child: ListTile(
        leading: Text(event.date.format()),
        title: Text(commentString),
      ),
    );
  }
}
