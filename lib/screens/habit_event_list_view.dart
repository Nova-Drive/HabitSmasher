import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/models/habit_event.dart';
import 'package:habitsmasher/screens/add_edit_habit_event_view.dart';
import 'package:habitsmasher/screens/habit_event_card_view.dart';
import 'package:habitsmasher/screens/habit_event_detail_view.dart';

class HabitEventList extends StatefulWidget {
  const HabitEventList({
    super.key,
    required this.habitEvents,
    required this.habit,
  });

  final List<HabitEvent> habitEvents;
  final Habit habit;

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
    // debugPrint('Sorted');
    // for (var event in widget.habitEvents) {
    //   debugPrint(event.date.toString());
    // }
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
        ElevatedButton(
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
              style: TextStyle(color: Color.fromARGB(255, 177, 144, 24)),
            )),
        Row(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text("Habit Events",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ))),
            ),

            // Add a sort button here
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: IconButton(
                      onPressed: () {
                        _sortEvents();
                        reverse = !reverse;
                      },
                      icon: Icon(
                        reverse ? Icons.arrow_downward : Icons.arrow_upward,
                        color: const Color.fromARGB(255, 177, 144, 24),
                      )),
                ))
          ],
        ),
        const Divider(
          thickness: 2,
          height: 3,
          color: Color.fromARGB(255, 100, 100, 100),
        ),
        ListView.builder(
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
                    actionPane: const SlidableDrawerActionPane(),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: "Edit",
                        color: Colors.blue,
                        icon: Icons.edit,
                        onTap: () {},
                      ),
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {},
                      )
                    ],
                    child: HabitEventCard(event: widget.habitEvents[index]),
                  ));
            })),
      ],
    );
  }
}
