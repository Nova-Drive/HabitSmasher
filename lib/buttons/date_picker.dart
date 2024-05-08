import 'package:flutter/material.dart';
import 'package:habitsmasher/extensions.dart';

class DatePicker extends StatefulWidget {
  const DatePicker(
      {super.key, required this.startDateController, required this.setDate});
  final TextEditingController startDateController;
  final Function setDate;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime startDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextField(
              readOnly: true,
              controller: widget.startDateController,
              // startDate.toString().substring(0, 10)
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: textFieldBorderRadius,
                ),
                labelText: "Start Date",
                hintText: startDate.toString().substring(0, 10),
              ),
              onTap: () => showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now(),
                  ).then((value) {
                    if (value != null) {
                      widget.setDate(value);
                    }
                  })),
        ),
        const SizedBox(width: 30),
        Ink(
          decoration: const ShapeDecoration(
            color: Colors.amber,
            shape: CircleBorder(),
          ),
          child: IconButton(
              onPressed: () => showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now(),
                  ).then((value) {
                    if (value != null) {
                      widget.setDate(value);
                    }
                  }),
              icon: const Icon(
                Icons.calendar_today_outlined,
              )),
        ),
        const SizedBox(width: 30),
      ],
    );
  }
}
