import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarContainer extends StatefulWidget {
  final DateTime? selectedDate1;
  final DateTime? selectedDate2;

  const CalendarContainer({
    Key? key,
    required this.selectedDate1,
    required this.selectedDate2,
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
    _selectedDate1 = DateTime.now();
    _selectedDate2 = DateTime.now().subtract(Duration(days: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '${_selectedDate2 == DateTime(0) ? '' : dformat.format(_selectedDate1)}',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
            SizedBox(
              width: 3,
            ),
            InkWell(
              onTap: () {
                _showDatePickerDialog(1);
              },
              child: Icon(
                FontAwesomeIcons.pen,
                size: 16,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              '${dformat.format(_selectedDate2)}',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
            SizedBox(
              width: 3,
            ),
            InkWell(
              onTap: () {
                _showDatePickerDialog(2);
              },
              child: Icon(
                FontAwesomeIcons.pen,
                size: 16,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: TableCalendar(
            calendarStyle: CalendarStyle(
              todayTextStyle: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              weekendTextStyle: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              weekNumberTextStyle: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              defaultTextStyle: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              disabledTextStyle: TextStyle(
                color: Color.fromRGBO(90, 90, 90, 1),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              selectedDecoration: BoxDecoration(
                  color: Color.fromRGBO(51, 132, 198, 1),
                  shape: BoxShape.circle),
              todayDecoration: BoxDecoration(
                  color: Color.fromRGBO(51, 132, 198, 1),
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
                }
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
      });
    }
  }
}
