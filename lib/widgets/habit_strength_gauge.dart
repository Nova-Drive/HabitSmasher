import 'package:flutter/material.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/models/habit_event.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HabitStrengthGauge extends StatelessWidget {
  final Habit habit;
  final List<HabitEvent> habitEvents;

  const HabitStrengthGauge({
    super.key,
    required this.habit,
    required this.habitEvents,
  });

  @override
  Widget build(BuildContext context) {
    double habitStrength = 0;

    if (habit.numPossibleEvents() != 0) {
      habitStrength = habitEvents.length / habit.numPossibleEvents() * 100;
    }

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
                        child: Text(
                          "Habit Strength\n${habitStrength.toStringAsFixed(0)}%",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ))),
              ],
              showLabels: false,
              showTicks: false,
              startAngle: 270,
              endAngle: 270,
              axisLineStyle: const AxisLineStyle(
                thickness: 1,
                color: Colors.amber,
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              pointers: <GaugePointer>[
                RangePointer(
                  value: habitStrength,
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
