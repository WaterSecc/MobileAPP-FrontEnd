import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

typedef DateRangeSelectedCallback = void Function(
    DateTime startDate, DateTime endDate);

class CalendarContainer extends StatefulWidget {
  final DateTime? selectedDate1;
  final DateTime? selectedDate2;
  final DateRangeSelectedCallback onDateRangeSelected;

  const CalendarContainer({
    Key? key,
    required this.selectedDate1,
    required this.selectedDate2,
    required this.onDateRangeSelected,
  }) : super(key: key);

  @override
  _CalendarContainerState createState() => _CalendarContainerState();
}

class _CalendarContainerState extends State<CalendarContainer> {
  late DateTime _selectedDate1;
  late DateTime _selectedDate2;
  final DateFormat dformat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _selectedDate1 = widget.selectedDate1 ?? DateTime.now();
    _selectedDate2 =
        widget.selectedDate2 ?? DateTime.now().subtract(Duration(days: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                '${_selectedDate2 == DateTime(0) ? '' : dformat.format(_selectedDate1)}',
                style: TextStyles.header5Style(
                    Theme.of(context).colorScheme.secondary),
              ),
            ),
            /*InkWell(
              onTap: () {
                _showDatePickerDialog(1);
              },
              child: Icon(FontAwesomeIcons.pen,
                  size: 16, color: Theme.of(context).colorScheme.secondary),
            ),*/
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                '${dformat.format(_selectedDate2)}',
                style: TextStyles.header5Style(
                    Theme.of(context).colorScheme.secondary),
              ),
            ),
            /*InkWell(
              onTap: () {
                _showDatePickerDialog(2);
              },
              child: Icon(FontAwesomeIcons.pen,
                  size: 16, color: Theme.of(context).colorScheme.secondary),
            ),*/
          ],
        ),
        Container(
          margin: EdgeInsets.all(2),
          child: TableCalendar(
            calendarStyle: CalendarStyle(
              todayTextStyle: TextStyles.subtitle6Style(
                  Theme.of(context).colorScheme.secondary),
              weekendTextStyle: TextStyles.subtitle6Style(
                  Theme.of(context).colorScheme.secondary),
              weekNumberTextStyle: TextStyles.subtitle6Style(
                  Theme.of(context).colorScheme.secondary),
              defaultTextStyle: TextStyles.subtitle6Style(
                  Theme.of(context).colorScheme.secondary),
              disabledTextStyle: TextStyles.subtitle6Style(gray),
              selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryFixed,
                  shape: BoxShape.circle),
              todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiaryFixed,
                  shape: BoxShape.circle),
            ),
            firstDay: DateTime.now().subtract(Duration(days: 365)),
            lastDay: DateTime.now(),
            focusedDay: DateTime.now(),
            selectedDayPredicate: (day) {
              return _selectedDate1 == day ||
                  _selectedDate2 == day ||
                  (_selectedDate1.isBefore(day) && _selectedDate2.isAfter(day));
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                if (_selectedDate2 != DateTime(0)) {
                  _selectedDate1 = selectedDay;
                  _selectedDate2 = DateTime(0);
                } else {
                  _selectedDate2 = selectedDay;
                  if (_selectedDate1.isAfter(_selectedDate2)) {
                    // Swap dates if the start date is after the end date
                    final temp = _selectedDate1;
                    _selectedDate1 = _selectedDate2;
                    _selectedDate2 = temp;
                  }
                }
                widget.onDateRangeSelected(_selectedDate1, _selectedDate2);
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [],
        ),
      ],
    );
  }

  Future<void> _showDatePickerDialog(int dateNumber) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: dateNumber == 1 ? _selectedDate1 : _selectedDate2,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        if (dateNumber == 1) {
          _selectedDate1 = selectedDate;
        } else {
          _selectedDate2 = selectedDate;
        }
        widget.onDateRangeSelected(_selectedDate1, _selectedDate2);
      });
    }
  }
}
