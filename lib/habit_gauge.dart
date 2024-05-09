import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
