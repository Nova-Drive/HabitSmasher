import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:habitsmasher/extensions.dart';
import 'package:habitsmasher/models/habit_event.dart';
import 'package:latlong2/latlong.dart';

class HabitEventDetailView extends StatelessWidget {
  final HabitEvent event;

  const HabitEventDetailView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Habit Event"),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              Row(
                children: [
                  //picture here
                  Image.asset(
                    "images/habit_temp_img.png",
                    width: MediaQuery.of(context).size.width * 0.50,
                  ),
                  Text(event.date.format()),
                ],
              ),
              Container(
                  padding: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width * 0.99,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(event.comment)),
              const Padding(padding: EdgeInsets.all(10)),
              if (event.location != null)
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: MapBox(event: event)),
            ],
          )),
        ));
  }
}

class MapBox extends StatelessWidget {
  const MapBox({
    super.key,
    required this.event,
  });

  final HabitEvent event;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width * 0.75,
        child: FlutterMap(
            // Maybe change this to a "paid" service later
            options: MapOptions(
                initialCenter: LatLng(
                    event.location!.latitude!, event.location!.longitude!),
                initialZoom: 15.0,
                interactionOptions:
                    const InteractionOptions(flags: InteractiveFlag.pinchZoom)),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.cm.habitsmasher',
              ),
            ]));
  }
}
