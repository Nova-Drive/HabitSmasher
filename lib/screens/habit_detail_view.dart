import 'package:flutter/material.dart';
import 'package:habitsmasher/buttons/weekday_button.dart';
import 'package:habitsmasher/extensions.dart';
import 'package:habitsmasher/habit_gauge.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/models/habit_event.dart';
import 'package:habitsmasher/network/network.dart';
import 'package:habitsmasher/screens/habit_event_list_view.dart';
import 'package:collection/collection.dart';

// ignore: must_be_immutable
class HabitDetailView extends StatefulWidget {
  final Habit habit;

  HabitDetailView({super.key, required this.habit});

  // This will be populated with the habit events for this habit
  // Populated here so that the habit events can be passed to other widgets
  List<HabitEvent> habitEvents = [];

  @override
  State<HabitDetailView> createState() => _HabitDetailViewState();
}

class _HabitDetailViewState extends State<HabitDetailView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const HabitStrengthGauge(),

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(widget.habit.description),
                    const Padding(padding: EdgeInsets.all(5)),
                    WeekdayButtons(
                        checked: widget.habit.daysToBool(),
                        selectable: false,
                        onChecked: ((bool isChecked, Days day) {})),
                  ],
                ),
                Text('Start Date: ${widget.habit.startDate.format()}'),

                EventList(widget: widget), //all the habit events
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EventList extends StatelessWidget {
  const EventList({
    super.key,
    required this.widget,
  });

  final HabitDetailView widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getHabitEvents(widget.habit),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<HabitEvent> habitEvents = snapshot.data as List<HabitEvent>;
            Function equals = const ListEquality().equals;
            if (equals(habitEvents, widget.habitEvents)) {
              debugPrint('Same events');
              return HabitEventList(
                  habit: widget.habit, habitEvents: widget.habitEvents);
            } else if (habitEvents.isEmpty) {
              return const Text('No events logged yet');
            }
            widget.habitEvents = habitEvents;
            return HabitEventList(
                habit: widget.habit, habitEvents: widget.habitEvents);
          } else {
            return const Center(
              // this is dumb but idk how else to make it look nice
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.amberAccent)),
                ],
              ),
            );
          }
        }));
  }
}
