import 'package:flutter/material.dart';
import 'package:habitsmasher/buttons/weekday_button.dart';
import 'package:habitsmasher/extensions.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/models/habit_event.dart';
import 'package:habitsmasher/sample_data/sample_data.dart';
import 'package:habitsmasher/screens/habit_event_list_view.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
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

class HabitStrengthGauge extends StatelessWidget {
  const HabitStrengthGauge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height * 0.35,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
              annotations: [
                GaugeAnnotation(
                    positionFactor: 0.5,
                    widget: CircleAvatar(
                        radius: MediaQuery.of(context).size.width *
                            0.24, //maybe change this later
                        backgroundColor: Colors.amberAccent,
                        child: const Text(
                          "Habit Strength\n50%",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ))),
              ],
              minimum: 0,
              maximum: 100,
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              axisLineStyle: const AxisLineStyle(
                thickness: 1,
                color: Colors.amber,
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              pointers: const <GaugePointer>[
                RangePointer(
                  value: 50,
                  width: 0.15,
                  color: Colors.white,
                  pointerOffset: 0.1,
                  cornerStyle: CornerStyle.bothCurve,
                  sizeUnit: GaugeSizeUnit.factor,
                )
              ])
        ],
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
        future: makeSampleHabitEvents(),
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
