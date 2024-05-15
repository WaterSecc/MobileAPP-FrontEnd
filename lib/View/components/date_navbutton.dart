import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:watersec_mobileapp_front/classes/chart_class.dart';

class DateNavigationButton extends StatefulWidget {
  @override
  _DateNavigationButtonState createState() => _DateNavigationButtonState();
}

class _DateNavigationButtonState extends State<DateNavigationButton> {
  DateTime currentDate = DateTime.now();
  final DateFormat dformat = DateFormat('dd/MM/yyyy');
  final DateFormat mformat = DateFormat('MMMM');
  final DateFormat yformat = DateFormat('yyyy');

  String selectedCategory = 'Day';
  Color dayButtonColor = Color.fromRGBO(51, 132, 198, 0);
  Color monthButtonColor = Color.fromRGBO(51, 132, 198, 1);
  Color yearButtonColor = Color.fromRGBO(51, 132, 198, 1);
  List<charts.Series<ChartData, String>> _seriesList = [];

  @override
  void initState() {
    super.initState();
    _seriesList = _createSeriesList();
  }

  List<charts.Series<ChartData, String>> _createSeriesList() {
    List<ChartData> data = [];
    DateTime currentDate = DateTime.now();

    if (selectedCategory == 'Day') {
      // Generate data for 7 days of the week
      List<String> daysOfWeek = [];
      for (int i = 6; i >= 0; i--) {
        DateTime date = currentDate.subtract(Duration(days: i));
        String dayLabel = DateFormat('E').format(date);
        daysOfWeek.add(dayLabel);
      }
      data = daysOfWeek.map((day) => ChartData(day, 2, 1)).toList();
    } else if (selectedCategory == 'Month') {
      // Generate data for 7 months including the current month
      List<String> months = [];
      for (int i = 6; i >= 0; i--) {
        DateTime date = DateTime(currentDate.year, currentDate.month - i, 1);
        String monthLabel = DateFormat('MMM').format(date);
        months.add(monthLabel);
      }
      data = months.map((month) => ChartData(month, 2, 1)).toList();
    } else if (selectedCategory == 'Year') {
      // Generate data for 5 years including the current year
      List<String> years = [];
      for (int i = 4; i >= 0; i--) {
        int year = currentDate.year - i;
        years.add(year.toString());
      }
      data = years.map((year) => ChartData(year, 2, 1)).toList();
    }
    return [
      charts.Series<ChartData, String>(
        id: 'Cold',
        domainFn: (ChartData data, _) => data.category,
        measureFn: (ChartData data, _) => data.coldLiters,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Color.fromRGBO(51, 132, 198, 1)),
        data: data,
      ),
      charts.Series<ChartData, String>(
        id: 'Hot',
        domainFn: (ChartData data, _) => data.category,
        measureFn: (ChartData data, _) => data.hotLiters,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Color.fromRGBO(249, 65, 68, 1)),
        data: data,
      ),
    ];
  }

  void updateDate(int change) {
    DateTime newDate = currentDate;

    if (selectedCategory == 'Day') {
      newDate = currentDate.add(Duration(days: change));
    } else if (selectedCategory == 'Month') {
      newDate = DateTime(
          currentDate.year, currentDate.month + change, currentDate.day);
    } else if (selectedCategory == 'Year') {
      newDate = DateTime(
          currentDate.year + change, currentDate.month, currentDate.day);
    }

    DateTime today = DateTime.now();
    if (newDate.isBefore(today) || selectedCategory == 'Day') {
      setState(() {
        currentDate = newDate;
      });
    }
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;

      if (category == 'Day') {
        dayButtonColor = Color.fromRGBO(51, 132, 198, 0);
        monthButtonColor = Color.fromRGBO(51, 132, 198, 1);
        yearButtonColor = Color.fromRGBO(51, 132, 198, 1);

        // Refresh the date to today's date
        currentDate = DateTime.now();
      } else if (category == 'Month') {
        dayButtonColor = Color.fromRGBO(51, 132, 198, 1);
        monthButtonColor = Color.fromRGBO(51, 132, 198, 0);
        yearButtonColor = Color.fromRGBO(51, 132, 198, 1);
      } else if (category == 'Year') {
        dayButtonColor = Color.fromRGBO(51, 132, 198, 1);
        monthButtonColor = Color.fromRGBO(51, 132, 198, 1);
        yearButtonColor = Color.fromRGBO(51, 132, 198, 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(51, 132, 198, 1),
                border: Border.all(
                    style: BorderStyle.solid,
                    color: Color.fromRGBO(51, 132, 198, 2)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 55,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selectCategory('Day');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dayButtonColor,
                    ),
                    child: Text(
                      'Day',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selectCategory('Month');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: monthButtonColor,
                    ),
                    child: Text(
                      'Month',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      selectCategory('Year');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yearButtonColor,
                    ),
                    child: Text(
                      'Year',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 35,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  updateDate(-1);
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text(
                    'Total 238 Litres',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: showCalendarPopup,
                    child: Text(
                      selectedCategory == 'Day'
                          ? '${dformat.format(currentDate)}'
                          : selectedCategory == 'Month'
                              ? '${mformat.format(currentDate)}'
                              : '${yformat.format(currentDate)}',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () {
                  updateDate(1);
                },
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 250,
            child: charts.BarChart(
              _seriesList,
              animate: true,
              defaultRenderer: charts.BarRendererConfig(
                groupingType: charts.BarGroupingType.stacked,
                strokeWidthPx: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCalendarPopup() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
    }
  }
}
