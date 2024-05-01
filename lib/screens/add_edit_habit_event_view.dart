import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habitsmasher/buttons/date_picker.dart';
import 'package:habitsmasher/extensions.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/models/habit_event.dart';
import 'package:location/location.dart';

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
  bool? addLocation = false;

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
  void dispose() {
    commentController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<LocationData> locationService() async {
    Location location = Location();
    await location.requestPermission();
    await location.requestService();
    LocationData place = await location.getLocation();
    return place;
  }

  void _addHabitEvent() {
    HabitEvent event = HabitEvent(
        comment: commentController.text, date: date, habit: widget.habit);

    if (addLocation!) {
      debugPrint('Adding location');
      locationService().then((LocationData place) {
        event.location = place;
      });
    }

    //picture stuff goes here

    _addEventToDb(event);
    Navigator.pop(context);
  }

  void _addEventToDb(HabitEvent event) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("habits")
        .where("id", isEqualTo: widget.habit.id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      db
          .collection("habits")
          .doc(querySnapshot.docs[0].id)
          .collection("events")
          .add(event.toMap());
    });
    widget.addHabitEvent!(event);
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
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                minLines: 3,
                maxLines: null,
                controller: commentController,
                decoration: InputDecoration(
                    labelText: 'Comment',
                    border: OutlineInputBorder(
                        borderRadius: textFieldBorderRadius)),
              ),
              DatePicker(
                  startDateController: dateController,
                  setDate: (date) {
                    setState(() {
                      this.date = date;
                      dateController.text = date.toString().substring(0, 10);
                    });
                  }),
              Row(children: [
                const Text('Add current location?'),
                Checkbox(
                    value: addLocation,
                    onChanged: (bool? value) => setState(() {
                          addLocation = value!;
                        }))
              ]),
              Row(children: [
                const Text("Add picture?"),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                ElevatedButton(
                    onPressed: () {
                      // add picture
                    },
                    child: const Text('Add Picture'))
              ]),
              const Padding(padding: EdgeInsets.all(15)),
              ElevatedButton(
                  onPressed: _addHabitEvent, child: const Text('Add Event')),
            ],
          ),
        ),
      ),
    );
  }
}
