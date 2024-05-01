import 'package:flutter/material.dart';
import 'package:habitsmasher/extensions.dart';
import 'package:habitsmasher/models/habit_event.dart';

class HabitEventCard extends StatelessWidget {
  final HabitEvent event;

  const HabitEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        // still needs picture eventually
        leading: Text(event.date.format()),
        title: Text(event.comment), //maybe only do substring plus "..." here
      ),
    );
  }
}
