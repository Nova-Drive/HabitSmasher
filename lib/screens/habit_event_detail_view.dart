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
          title: Text(event.date.format()),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              _BorderBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: event.imagePath != null
                    ? Image.network(
                        event.imagePath!,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const CircularProgressIndicator();
                        },
                      )
                    : Image.asset(
                        "images/habit_temp_img.png",
                      ),
              ),
              if (event.location != null)
                _BorderBox(child: MapBox(event: event)),
              _BorderBox(
                width: double.infinity,
                child:
                    Text(event.comment, style: const TextStyle(fontSize: 18)),
              ),
              const Padding(padding: EdgeInsets.all(10)),
            ],
          )),
        ));
  }
}

class _BorderBox extends StatelessWidget {
  final Widget child;
  final Color backgroundColor = Colors.green[50]!;
  final double? width;

  _BorderBox({required this.child, this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          padding: const EdgeInsets.all(8),
          width: width ?? MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: Colors.brown, width: 3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child),
    );
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
