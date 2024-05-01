import 'package:flutter/material.dart';
import 'package:habitsmasher/extensions.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/models/habit_event.dart';

class AddEditHabitEventView extends StatefulWidget {
  final Function? addHabitEvent;
  final Function? editHabitEvent;
  final HabitEvent? habitEvent;
  final Habit habit;

  const AddEditHabitEventView(
      {super.key,
      required this.habit,
      this.addHabitEvent,
      this.editHabitEvent,
      this.habitEvent});

  @override
  State<AddEditHabitEventView> createState() => _AddEditHabitEventViewState();
}

class _AddEditHabitEventViewState extends State<AddEditHabitEventView> {
  Operation? operation;
  TextEditingController commentController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime date = DateTime.now();
  String location = '';

  @override
  void initState() {
    super.initState();

    if (widget.habitEvent != null && widget.editHabitEvent != null) {
      operation = Operation.edit;
      // set the values of the form fields to the values of the habit event
    } else if (widget.addHabitEvent != null) {
      operation = Operation.add;
      // set the values of the form fields to the default values
    } else {
      // throw an error
      throw Exception(
          'Invalid function call. Must provide either add or edit function.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(operation == Operation.add
            ? 'Add Habit Event'
            : 'Edit Habit Event'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: commentController,
                decoration: const InputDecoration(labelText: 'Comment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
