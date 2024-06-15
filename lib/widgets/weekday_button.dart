import 'package:flutter/material.dart';
import 'package:habitsmasher/models/habit.dart';
import 'package:habitsmasher/theme.dart';

class WeekdayButton extends StatefulWidget {
  const WeekdayButton(
      {super.key,
      required this.onChecked,
      required this.day,
      this.isChecked = false,
      this.selectable = true});
  final Function(bool, Days) onChecked;
  final Days day;
  final bool isChecked;
  final bool selectable;
  @override
  State<WeekdayButton> createState() => _WeekdayButtonState();
}

class _WeekdayButtonState extends State<WeekdayButton> {
  bool isChecked = false;

  @override
  void initState() {
    isChecked = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (!widget.selectable) return;
            isChecked = !isChecked;
            widget.onChecked(isChecked, widget.day);
          });
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isChecked ? theme.primaryColor : Colors.white,
            border: Border.all(),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              widget.day.name.substring(0, 3),
              style: TextStyle(
                color: isChecked ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WeekdayButtons extends StatelessWidget {
  const WeekdayButtons(
      {super.key,
      required this.checked,
      required this.onChecked,
      this.selectable = true});
  final List<bool> checked;
  final bool selectable;

  final Function(bool, Days) onChecked;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        WeekdayButton(
            onChecked: _onChecked,
            day: Days.monday,
            isChecked: checked[0],
            selectable: selectable),
        WeekdayButton(
            onChecked: _onChecked,
            day: Days.tuesday,
            isChecked: checked[1],
            selectable: selectable),
        WeekdayButton(
            onChecked: _onChecked,
            day: Days.wednesday,
            isChecked: checked[2],
            selectable: selectable),
        WeekdayButton(
            onChecked: _onChecked,
            day: Days.thursday,
            isChecked: checked[3],
            selectable: selectable),
        WeekdayButton(
            onChecked: _onChecked,
            day: Days.friday,
            isChecked: checked[4],
            selectable: selectable),
        WeekdayButton(
            onChecked: _onChecked,
            day: Days.saturday,
            isChecked: checked[5],
            selectable: selectable),
        WeekdayButton(
            onChecked: _onChecked,
            day: Days.sunday,
            isChecked: checked[6],
            selectable: selectable),
      ],
    );
  }

  void _onChecked(bool checked, Days day) {
    onChecked(checked, day);
  }
}
