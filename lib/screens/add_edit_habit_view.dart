import 'package:flutter/material.dart';
import 'package:habitsmasher/widgets/date_picker.dart';
import 'package:habitsmasher/widgets/weekday_button.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/extensions.dart';
import 'package:habitsmasher/theme.dart';

class AddEditHabitView extends StatefulWidget {
  final Habit? habit;
  final Function? addHabit;
  final Function? editHabit;
  final int? index;
  final Operation operation;

  const AddEditHabitView(
      {super.key,
      this.addHabit,
      this.editHabit,
      this.habit,
      this.index,
      required this.operation});

  //need special controller for the start date, it's a time picker

  @override
  State<AddEditHabitView> createState() => _AddEditHabitViewState();
}

class _AddEditHabitViewState extends State<AddEditHabitView> {
  final TextEditingController habitNameController = TextEditingController();
  final TextEditingController habitDescriptionController =
      TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  DateTime startDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  // I don't like doing it this way but I'll figure out a better way another day
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;
  bool sunday = false;

  @override
  void initState() {
    if (widget.operation == Operation.edit) {
      assert(widget.habit != null);
      assert(widget.editHabit != null);
      assert(widget.index != null);
      habitNameController.text = widget.habit!.name;
      habitDescriptionController.text = widget.habit!.description;
      startDate = widget.habit!.startDate;

      for (Days day in widget.habit!.recurranceDays) {
        switch (day) {
          case Days.monday:
            monday = true;
            break;
          case Days.tuesday:
            tuesday = true;
            break;
          case Days.wednesday:
            wednesday = true;
            break;
          case Days.thursday:
            thursday = true;
            break;
          case Days.friday:
            friday = true;
            break;
          case Days.saturday:
            saturday = true;
            break;
          case Days.sunday:
            sunday = true;
            break;
        }
      }
    } else {
      assert(widget.operation == Operation.add);
      assert(widget.addHabit != null);
    }
    super.initState();
  }

  @override
  void dispose() {
    habitNameController.dispose();
    habitDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    startDateController.text = startDate.toString().substring(0, 10);

    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: Text(
              widget.operation == Operation.add ? 'Add Habit' : 'Edit Habit'),
        ),
        body: Center(
          child: GestureDetector(
            // unfocus the text fields when the user taps outside of them
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: habitNameController,
                    maxLength: 20,
                    decoration: inputDecoration(labelText: "Habit Name"),
                  ),
                  const _Spacer(),
                  TextField(
                    controller: habitDescriptionController,
                    decoration: inputDecoration(labelText: "Description"),
                  ),
                  const _Spacer(),
                  // Date with row containing textbox and calendar icon

                  // Weekdays with row containing 7 checkboxes
                  WeekdayButtons(onChecked: _onChecked, checked: [
                    monday,
                    tuesday,
                    wednesday,
                    thursday,
                    friday,
                    saturday,
                    sunday
                  ]),

                  const _Spacer(),

                  DatePicker(
                      startDateController: startDateController,
                      setDate: (date) {
                        setState(() {
                          startDate = date;
                        });
                      }),
                  const _Spacer(),

                  widget.operation == Operation.edit
                      ? ElevatedButton(
                          style: theme.elevatedButtonTheme.style,
                          onPressed: _editHabit,
                          child: const Text("Edit Habit"),
                        )
                      : ElevatedButton(
                          style: theme.elevatedButtonTheme.style,
                          onPressed: _makeHabit,
                          child: const Text("Add Habit"),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _validate() {
    if (habitNameController.text.isEmpty) {
      throw NoTitleException('Habit name cannot be empty');
    }
    if (habitDescriptionController.text.isEmpty) {
      //show description is empty error
      throw NoDescriptionException('Habit description cannot be empty');
    }
    if (!_getDays().isNotEmpty) {
      //show no days selected error
      throw NoDaysException('At least one day must be selected');
    }
    if (startDate.isAfter(DateTime.now())) {
      // This should never fire because the date picker should not allow future dates
      // But just in case it's in here
      throw Exception('Start date cannot be in the future');
    }
  }

  void _makeHabit() {
    try {
      _validate();
    } on Exception catch (e) {
      showException(context, e);
      return;
    }
    final Habit habit = Habit(
      name: habitNameController.text,
      description: habitDescriptionController.text,
      recurranceDays: _getDays(),
      startDate: startDate,
    );
    widget.addHabit!(habit);
    Navigator.pop(context);
  }

  void _editHabit() {
    try {
      _validate();
    } on Exception catch (e) {
      showException(context, e);
      return;
    }
    final Habit habit = Habit(
      name: habitNameController.text,
      description: habitDescriptionController.text,
      recurranceDays: _getDays(),
      startDate: startDate,
    );

    widget.editHabit!(habit, widget.habit!);
    Navigator.pop(context);
  }

  List<Days> _getDays() {
    List<Days> days = [];
    if (monday) {
      days.add(Days.monday);
    }
    if (tuesday) {
      days.add(Days.tuesday);
    }
    if (wednesday) {
      days.add(Days.wednesday);
    }
    if (thursday) {
      days.add(Days.thursday);
    }
    if (friday) {
      days.add(Days.friday);
    }
    if (saturday) {
      days.add(Days.saturday);
    }
    if (sunday) {
      days.add(Days.sunday);
    }
    return days;
  }

  void _onChecked(bool checked, Days day) {
    setState(() {
      switch (day) {
        case Days.monday:
          monday = checked;
          break;
        case Days.tuesday:
          tuesday = checked;
          break;
        case Days.wednesday:
          wednesday = checked;
          break;
        case Days.thursday:
          thursday = checked;
          break;
        case Days.friday:
          friday = checked;
          break;
        case Days.saturday:
          saturday = checked;
          break;
        case Days.sunday:
          sunday = checked;
          break;
      }
    });
  }
}

class _Spacer extends StatelessWidget {
  const _Spacer();

  @override
  Widget build(BuildContext context) {
    return const Padding(padding: EdgeInsets.only(top: 12));
  }
}

class NoTitleException implements Exception {
  final String message;
  @override
  String toString() {
    return message;
  }

  NoTitleException(this.message);
}

class NoDescriptionException implements Exception {
  final String message;
  @override
  String toString() {
    return message;
  }

  NoDescriptionException(this.message);
}

class NoDaysException implements Exception {
  final String message;

  @override
  String toString() {
    return message;
  }

  NoDaysException(this.message);
}
