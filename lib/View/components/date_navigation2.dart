import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/ViewModel/day_periodConsumptionViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/month_periodConsumptionViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/year_periodConsumptionViewModel.dart';

import 'package:watersec_mobileapp_front/classes/chart_class.dart';
import 'package:watersec_mobileapp_front/classes/consumption.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class DateNavigationButton2 extends StatefulWidget {
  @override
  _DateNavigationButton2State createState() => _DateNavigationButton2State();
}

class _DateNavigationButton2State extends State<DateNavigationButton2> {
  bool _isLoading = true;
  DateTime currentDate = DateTime.now();
  final DateFormat dformat = DateFormat('dd/MM/yyyy');
  final DateFormat mformat = DateFormat('MMMM');
  final DateFormat yformat = DateFormat('yyyy');

  String selectedCategory = 'Day';
  Color dayButtonColor = darkBlue;
  Color monthButtonColor = blue;
  final _dayperiodViewModel = DayPeriodConsumptionViewModel();
  final _monthperiodViewModel = MonthPeriodConsumptionViewModel();
  final _yearperiodViewModel = YearPeriodConsumptionViewModel();
  Color yearButtonColor = blue;
  List<String> _todaydates = [];
  List<Consumption> _consumptions = [];
  num _todaystotal = 0.0;
  num _monthstotal = 0.0;
  num _yearstotal = 0.0;
  num total = 0.0;
  List<String> _monthdates = [];
  List<String> _yeardates = [];

  @override
  void initState() {
    super.initState();
    _fetchtoday();
    _fetchthismonth();
    _fetchthisyear();
  }

  Future<void> _fetchtoday() async {
    setState(() {
      _isLoading = true;
    });
    await _dayperiodViewModel.fetchDayPeriodConsumption();
    setState(() {
      _isLoading = false;
      _todaydates = _dayperiodViewModel.dates;
      _consumptions = _dayperiodViewModel.consumptions;
      _todaystotal = _dayperiodViewModel.total;
    });
  }

  Future<void> _fetchthismonth() async {
    setState(() {
      _isLoading = true;
    });
    await _monthperiodViewModel.fetchMonthPeriodConsumption();
    setState(() {
      _isLoading = false;
      _monthdates = _monthperiodViewModel.dates;
      _consumptions = _monthperiodViewModel.consumptions;
      _monthstotal = _monthperiodViewModel.total;
    });
  }

  Future<void> _fetchthisyear() async {
    setState(() {
      _isLoading = true;
    });
    await _yearperiodViewModel.fetchYearPeriodConsumption();
    setState(() {
      _isLoading = false;
      _yeardates = _yearperiodViewModel.dates;
      _consumptions = _yearperiodViewModel.consumptions;
      _yearstotal = _yearperiodViewModel.total;
    });
  }

  List<ChartSeries<ChartDataBar, String>> _createSeriesList() {
    List<ChartDataBar> data = [];
    DateTime currentDate = DateTime.now();

    if (selectedCategory == 'Day') {
      for (int i = 0; i < _todaydates.length; i++) {
        double coldValue =
            _consumptions.firstWhere((c) => c.tag == 'cold').values[i];
        double hotValue =
            _consumptions.firstWhere((c) => c.tag == 'hot').values[i];
        data.add(ChartDataBar(
          _todaydates[i],
          coldValue,
          hotValue,
        ));
      }
    } else if (selectedCategory == 'Month') {
      int maxLength = 0;
      for (var consumption in _consumptions) {
        if (consumption.values.length > maxLength) {
          maxLength = consumption.values.length;
        }
      }

      for (int i = 0; i < maxLength; i++) {
        double? coldValue =
            i < _consumptions.firstWhere((c) => c.tag == 'cold').values.length
                ? _consumptions.firstWhere((c) => c.tag == 'cold').values[i]
                : null;
        double? hotValue =
            i < _consumptions.firstWhere((c) => c.tag == 'hot').values.length
                ? _consumptions.firstWhere((c) => c.tag == 'hot').values[i]
                : null;

        DateTime date =
            DateTime.now().subtract(Duration(days: maxLength - i - 1));
        data.add(ChartDataBar(
          DateFormat('MMM d').format(date),
          coldValue ?? 0,
          hotValue ?? 0,
        ));
      }
    } else if (selectedCategory == 'Year') {
      for (int i = 0; i < _yeardates.length; i++) {
        double coldValue =
            _consumptions.firstWhere((c) => c.tag == 'cold').values[i];
        double hotValue =
            _consumptions.firstWhere((c) => c.tag == 'hot').values[i];
        data.add(ChartDataBar(
          _yeardates[i],
          coldValue,
          hotValue,
        ));
      }
    }

    return [
      ColumnSeries<ChartDataBar, String>(
        name: 'Cold',
        color: blue,
        dataSource: data,
        xValueMapper: (ChartDataBar data, _) => data.date,
        yValueMapper: (ChartDataBar data, _) => data.coldLiters,
      ),
      ColumnSeries<ChartDataBar, String>(
        name: 'Hot',
        color: red,
        dataSource: data,
        xValueMapper: (ChartDataBar data, _) => data.date,
        yValueMapper: (ChartDataBar data, _) => data.hotLiters,
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
        total = _todaystotal;

        // Refresh the date to today's date
        currentDate = DateTime.now();
      } else if (category == 'Month') {
        dayButtonColor = blue;
        monthButtonColor = darkBlue;
        yearButtonColor = blue;
        total = _monthstotal;
      } else if (category == 'Year') {
        dayButtonColor = blue;
        monthButtonColor = blue;
        yearButtonColor = darkBlue;
        total = _yearstotal;
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
                    AppLocale.Total.getString(context) +
                        ' ' +
                        total.toStringAsFixed(2) +
                        'L',
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
              tooltipBehavior: TooltipBehavior(
                enable: true,
                builder: _customTooltipTemplate,
              ),
              series: _createSeriesList()
                  .cast<CartesianSeries<ChartDataBar, String>>(),
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

  Widget _customTooltipTemplate(dynamic data, ChartPoint<dynamic> point,
      ChartSeries<dynamic, dynamic> series, int pointIndex, int seriesIndex) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cold: ${(data as ChartDataBar).coldLiters} L',
            style: TextStyles.subtitle6Style(
              Theme.of(context).colorScheme.secondary,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Hot: ${(data as ChartDataBar).hotLiters} L',
            style: TextStyles.subtitle6Style(
              Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
