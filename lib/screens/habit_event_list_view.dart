import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/models/habit_event.dart';
import 'package:habitsmasher/screens/add_edit_habit_event_view.dart';
import 'package:habitsmasher/screens/habit_event_card_view.dart';
import 'package:habitsmasher/screens/habit_event_detail_view.dart';
import 'package:habitsmasher/theme.dart';

class HabitEventList extends StatefulWidget {
  const HabitEventList({
    super.key,
    required this.habitEvents,
    required this.habit,
    required this.editEvent,
  });

  final List<HabitEvent> habitEvents;
  final Habit habit;
  final Function editEvent;

  @override
  State<HabitEventList> createState() => _HabitEventListState();
}

class _HabitEventListState extends State<HabitEventList> {
  bool reverse = false;
  void _sortEvents() {
    setState(() {
      if (reverse) {
        widget.habitEvents.sort((a, b) => b.date.compareTo(a.date));
      } else {
        widget.habitEvents.sort((a, b) => a.date.compareTo(b.date));
      }
    });
  }

  void _deleteEvent(int index) async {
    HabitEvent event = widget.habitEvents[index];
    FirebaseFirestore db = FirebaseFirestore.instance;
    String habitId = "";
    String eventId = "";

    await db
        .collection("habits")
        .where("id", isEqualTo: widget.habit.id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      habitId = querySnapshot.docs[0].id;
    });
    await db
        .collection("habits")
        .doc(habitId)
        .collection("events")
        .where("id", isEqualTo: event.id)
        .get()
        .then((QuerySnapshot querySnapshotTwo) {
      eventId = querySnapshotTwo.docs[0].id;
    });

    await db
        .collection("habits")
        .doc(habitId)
        .collection("events")
        .doc(eventId)
        .delete();
    setState(() {
      widget.habitEvents.remove(event);
    });
  }

  void _editEvent(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEditHabitEventView(
                  habit: widget.habit,
                  habitEvent: widget.habitEvents[index],
                  editHabitEvent: (HabitEvent event) {
                    widget.editEvent();
                    setState(() {
                      widget.habitEvents[index] = event;
                    });
                  },
                )));
  }

  @override
  void initState() {
    super.initState();
    // better to just sort instead of calling sortEvents, saves a setState
    //sortEvents(reverse: false);
    widget.habitEvents.sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("Habit Events",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ))),

            // Add a sort button here
            IconButton(
                onPressed: () {
                  _sortEvents();
                  reverse = !reverse;
                },
                icon: Icon(
                  reverse ? Icons.arrow_downward : Icons.arrow_upward,
                  color: const Color.fromARGB(255, 177, 144, 24),
                )),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                  style: theme.elevatedButtonTheme.style,
                  onPressed: () {
                    // Add a new habit
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditHabitEventView(
                            habit: widget.habit,
                            addHabitEvent: (HabitEvent event) {
                              setState(() {
                                widget.habitEvents.add(event);
                              });
                            },
                          ),
                        ));
                  },
                  child: const Text(
                    'Add Event',
                  )),
            ),
          ],
        ),
        const Divider(
          thickness: 2,
          height: 3,
          color: Color.fromARGB(255, 100, 100, 100),
        ),
        if (widget.habitEvents.isEmpty)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('No events yet'),
          )
        else
          (ListView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // never want this scrollable
              shrinkWrap: true,
              // Need to make sure there's at least one event
              itemCount: widget.habitEvents.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HabitEventDetailView(
                                    event: widget.habitEvents[index],
                                  )));
                    },
                    child: Slidable(
                      endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: 0.5,
                          openThreshold: 0.2,
                          closeThreshold: 0.8,
                          children: <Widget>[
                            SlidableAction(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                label: "Edit",
                                backgroundColor: Colors.blue,
                                icon: Icons.edit,
                                onPressed: (context) {
                                  _editEvent(index);
                                }),
                            SlidableAction(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              label: 'Delete',
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                              onPressed: (context) {
                                _deleteEvent(index);
                              },
                            )
                          ]),
                      child: HabitEventCard(event: widget.habitEvents[index]),
                    ));
              }))),
      ],
    );
  }
}
