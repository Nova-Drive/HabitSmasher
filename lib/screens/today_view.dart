import 'package:flutter/material.dart';
import 'package:habitsmasher/extensions.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/screens/habit_list_view.dart';
import 'package:habitsmasher/theme.dart';

class TodayView extends StatefulWidget {
  final List<Habit> habits;
  final Function editHabit;
  final Function deleteHabit;

  final int dayOfWeek = DateTime.now().toLocal().weekday - 1;

  TodayView(
      {super.key,
      required this.habits,
      required this.editHabit,
      required this.deleteHabit});

  @override
  State<TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  List<Habit> habitsForToday = [];
  @override
  void initState() {
    habitsForToday = widget.habits
        .where((habit) => habit.recurranceDays
            .contains(Days.values[DateTime.now().weekday - 1]))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: // maybe add full date here
              Text(Days.values[widget.dayOfWeek].name.capitalize(),
                  style: theme.appBarTheme.titleTextStyle),
        ),
        body: habitsForToday.isEmpty
            ? const Center(
                child: Text("No Habits for today!",
                    style: TextStyle(fontSize: 20)))
            : habitCards(
                habits: habitsForToday,
                editHabit: widget.editHabit,
                deleteHabit: widget.deleteHabit));
  }
}
