import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/ViewModel/day_periodConsumptionViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/month_periodConsumptionViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/year_periodConsumptionViewModel.dart';
import 'dart:math' as math;
import 'package:watersec_mobileapp_front/classes/chart_class.dart';
import 'package:watersec_mobileapp_front/classes/consumption.dart';
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
  num total = 0.0;

  @override
  void initState() {
    super.initState();
    final dayperiodViewModel = context.read<DayPeriodConsumptionViewModel>();
    final monthperiodViewModel =
        context.read<MonthPeriodConsumptionViewModel>();
    final yearperiodViewModel = context.read<YearPeriodConsumptionViewModel>();
    dayperiodViewModel.fetchDayPeriodConsumption();
    monthperiodViewModel.fetchMonthPeriodConsumption();
    yearperiodViewModel.fetchYearPeriodConsumption();
  }

  List<ChartSeries<ChartDataBar, String>> _createSeriesList(
    DayPeriodConsumptionViewModel dayperiodViewModel,
    MonthPeriodConsumptionViewModel monthperiodViewModel,
    YearPeriodConsumptionViewModel yearperiodViewModel,
    void Function(num) updateTotal,
  ) {
    List<ChartDataBar> data = [];
    num total = 0.0;

    if (selectedCategory == 'Day') {
      for (int i = 0; i < dayperiodViewModel.dates.length; i++) {
        double coldValue = dayperiodViewModel.consumptions
            .firstWhere((c) => c.tag == 'cold')
            .values[i];
        double hotValue = dayperiodViewModel.consumptions
            .firstWhere((c) => c.tag == 'hot')
            .values[i];
        data.add(ChartDataBar(
          dayperiodViewModel.dates[i],
          coldValue,
          hotValue,
        ));
        total = dayperiodViewModel.total;
      }
    } else if (selectedCategory == 'Month') {
      for (int i = 0; i < monthperiodViewModel.dates.length; i++) {
        double coldValue = monthperiodViewModel.consumptions
            .firstWhere((c) => c.tag == 'cold')
            .values[i];
        double hotValue = monthperiodViewModel.consumptions
            .firstWhere((c) => c.tag == 'hot')
            .values[i];
        data.add(ChartDataBar(
          monthperiodViewModel.dates[i],
          coldValue,
          hotValue,
        ));
        total = monthperiodViewModel.total;
      }
    } else if (selectedCategory == 'Year') {
      for (int i = 0; i < yearperiodViewModel.dates.length; i++) {
        double coldValue = yearperiodViewModel.consumptions
            .firstWhere((c) => c.tag == 'cold')
            .values[i];
        double hotValue = yearperiodViewModel.consumptions
            .firstWhere((c) => c.tag == 'hot')
            .values[i];
        data.add(ChartDataBar(
          yearperiodViewModel.dates[i],
          coldValue,
          hotValue,
        ));
        total = yearperiodViewModel.total;
      }
    }
    updateTotal(total);
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

  void selectCategory(String category, num total) {
    setState(() {
      selectedCategory = category;

      if (category == 'Day') {
        dayButtonColor = darkBlue;
        monthButtonColor = blue;
        yearButtonColor = blue;
        total;

        // Refresh the date to today's date
        currentDate = DateTime.now();
      } else if (category == 'Month') {
        dayButtonColor = blue;
        monthButtonColor = darkBlue;
        yearButtonColor = blue;
        total;
      } else if (category == 'Year') {
        dayButtonColor = blue;
        monthButtonColor = blue;
        yearButtonColor = darkBlue;
        total;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dayperiodViewModel = context.watch<DayPeriodConsumptionViewModel>();
    final monthperiodViewModel =
        context.watch<MonthPeriodConsumptionViewModel>();
    final yearperiodViewModel = context.watch<YearPeriodConsumptionViewModel>();
    bool _isLoading = yearperiodViewModel.total == 0 &&
        monthperiodViewModel.total == 0 &&
        dayperiodViewModel.total == 0;
    List<ChartSeries<ChartDataBar, String>> seriesList = _createSeriesList(
      dayperiodViewModel,
      monthperiodViewModel,
      yearperiodViewModel,
      (num updatedTotal) {
        setState(() {
          total = updatedTotal;
        });
      },
    );

    // Define the custom tooltip template here so it has access to context
    Widget _customTooltipTemplate(dynamic data, ChartPoint<dynamic> point,
        ChartSeries<dynamic, dynamic> series, int pointIndex, int seriesIndex) {
      return SizedBox(
        height: 80,
        width: 150,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
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
              Center(
                child: Text(
                  '${(data as ChartDataBar).date} ',
                  style: TextStyles.subtitle6Style(
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 2, right: 3),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: blue,
                    ),
                  ),
                  Text(
                    'Cold: ${(data as ChartDataBar).coldLiters} L',
                    style: TextStyles.subtitle6Style(
                      Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 2, right: 3),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: red,
                    ),
                  ),
                  Text(
                    'Hot: ${(data as ChartDataBar).hotLiters} L',
                    style: TextStyles.subtitle6Style(
                      Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      child: Skeletonizer(
        enabled: _isLoading,
        ignoreContainers: true,
        child: Column(
          children: [
            // Date Navigation Buttons with Blue Background
            Container(
              width: double.infinity, // Ensure full width
              color: blue, // Blue background for the entire container
              padding: const EdgeInsets.symmetric(
                  vertical: 0.01), // Vertical padding
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Ensure equal spacing
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        selectCategory('Day', dayperiodViewModel.total);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dayButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(
                        AppLocale.Day.getString(context),
                        style: TextStyles.DatenavBtn(white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // Add a little gap between buttons
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        selectCategory('Month', monthperiodViewModel.total);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: monthButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(
                        AppLocale.Month.getString(context),
                        style: TextStyles.DatenavBtn(white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        selectCategory('Year', yearperiodViewModel.total);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yearButtonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(
                        AppLocale.Year.getString(context),
                        style: TextStyles.DatenavBtn(white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Chart Section
            SizedBox(
              height: 250,
              child: SfCartesianChart(
                key: const Key('chart'),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  builder: _customTooltipTemplate,
                ),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true,
                  enablePinching: true,
                  enableSelectionZooming: true,
                  zoomMode: ZoomMode.x,
                ),
                series:
                    seriesList.cast<CartesianSeries<ChartDataBar, String>>(),
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 10,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                  ),
                  plotOffset: 20,
                  autoScrollingMode: AutoScrollingMode.end,
                  autoScrollingDelta: 4,
                ),
                primaryYAxis: NumericAxis(
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 10,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                  ),
                ),
                title: ChartTitle(
                  text: AppLocale.Total.getString(context) +
                      ' ' +
                      total.toStringAsFixed(2) +
                      'L',
                  textStyle: TextStyles.header5Style(
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
