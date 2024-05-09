import 'package:flutter/material.dart';
import 'package:habitsmasher/buttons/weekday_button.dart';
import 'package:habitsmasher/extensions.dart';
import 'package:habitsmasher/habit_strength_gauge.dart';
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
        body: FutureBuilder(
          future: getHabitEvents(widget.habit),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<HabitEvent> habitEvents = snapshot.data as List<HabitEvent>;
              Function equals = const ListEquality().equals;
              if (equals(habitEvents, widget.habitEvents)) {
                debugPrint('Same events');
                return _DetailView(widget: widget);
              } else if (habitEvents.isEmpty) {
                return const Text('No events logged yet');
              }
              widget.habitEvents = habitEvents;
              return _DetailView(widget: widget);
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
          }),
        ));
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({
    super.key,
    required this.widget,
  });

  final HabitDetailView widget;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HabitStrengthGauge(
                  habit: widget.habit, habitEvents: widget.habitEvents),

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

              HabitEventList(
                  habitEvents: widget.habitEvents,
                  habit: widget.habit), //all the habit events
            ],
          ),
        ),
      ),
    );
  }
}
