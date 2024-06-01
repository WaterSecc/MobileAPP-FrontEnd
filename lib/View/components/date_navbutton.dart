import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';

import 'package:watersec_mobileapp_front/classes/chart_class.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

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
  Color dayButtonColor = darkBlue;
  Color monthButtonColor = blue;
  Color yearButtonColor = blue;
  //List<charts.Series<ChartData, String>> _seriesList = [];

  @override
  void initState() {
    super.initState();
    //_seriesList = _createSeriesList();
  }

  List<ChartSeries<ChartData, String>> _createSeriesList() {
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
      ColumnSeries<ChartData, String>(
        name: 'Cold',
        color: blue,
        dataSource: data,
        xValueMapper: (ChartData data, _) => data.category,
        yValueMapper: (ChartData data, _) => data.coldLiters,
      ),
      ColumnSeries<ChartData, String>(
        name: 'Hot',
        color: red,
        dataSource: data,
        xValueMapper: (ChartData data, _) => data.category,
        yValueMapper: (ChartData data, _) => data.hotLiters,
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
        dayButtonColor = darkBlue;
        monthButtonColor = blue;
        yearButtonColor = blue;

        // Refresh the date to today's date
        currentDate = DateTime.now();
      } else if (category == 'Month') {
        dayButtonColor = blue;
        monthButtonColor = darkBlue;
        yearButtonColor = blue;
      } else if (category == 'Year') {
        dayButtonColor = blue;
        monthButtonColor = blue;
        yearButtonColor = darkBlue;
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
                color: blue,
                border: Border.all(
                  style: BorderStyle.solid,
                  color: Theme.of(context).cardColor,
                ),
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
                      AppLocale.Day.getString(context),
                      style: TextStyles.DatenavBtn(white),
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
                      AppLocale.Month.getString(context),
                      style: TextStyles.DatenavBtn(white),
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
                      AppLocale.Year.getString(context),
                      style: TextStyles.DatenavBtn(white),
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
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text(
                    AppLocale.Total.getString(context)+' 238 Litres',
                    style: TextStyles.header5Style(
                      Theme.of(context).colorScheme.secondary,
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
                      style: TextStyles.header5Style(
                        Theme.of(context).colorScheme.secondary,
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
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 250,
            child: SfCartesianChart(
              series: _createSeriesList()
                  .cast<CartesianSeries<ChartData, String>>(),
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              title: ChartTitle(
                text: AppLocale.WaterC.getString(context),
                textStyle: TextStyles.subtitle5Style(
                  Theme.of(context).colorScheme.secondary,
                ),
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
