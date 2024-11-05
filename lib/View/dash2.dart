import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
import 'package:watersec_mobileapp_front/View/components/textBtnNotOutlined.dart';
import 'package:watersec_mobileapp_front/ViewModel/DashboardViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/day_periodConsumptionViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/watermeterViewModel.dart';
import 'package:watersec_mobileapp_front/classes/chartData.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class Dashboard2 extends StatefulWidget {
  const Dashboard2({Key? key}) : super(key: key);

  @override
  State<Dashboard2> createState() => _Dashboard2State();
}

class _Dashboard2State extends State<Dashboard2> {
  final DateTime currentTime = DateTime.now();
  final DateFormat hourFormat = DateFormat('hh');
  final DateFormat amPmFormat = DateFormat('a');

  List<ChartData> _createSeriesList(
      DayPeriodConsumptionViewModel dayperiodViewModel) {
    double totalCold = 0.0;
    double totalHot = 0.0;

    for (int i = 0; i < dayperiodViewModel.dates.length; i++) {
      totalCold += dayperiodViewModel.consumptions
          .firstWhere((c) => c.tag == 'cold')
          .values[i];
      totalHot += dayperiodViewModel.consumptions
          .firstWhere((c) => c.tag == 'hot')
          .values[i];
    }

    return [
      ChartData('Hot', totalHot, red),
      ChartData('Cold', totalCold, blue),
    ];
  }

  double _getColdConsumption(DayPeriodConsumptionViewModel dayperiodViewModel) {
    double totalCold = 0.0;
    for (int i = 0; i < dayperiodViewModel.dates.length; i++) {
      totalCold += dayperiodViewModel.consumptions
          .firstWhere((c) => c.tag == 'cold')
          .values[i];
    }
    return totalCold;
  }

  double _getHotConsumption(DayPeriodConsumptionViewModel dayperiodViewModel) {
    double totalHot = 0.0;
    for (int i = 0; i < dayperiodViewModel.dates.length; i++) {
      totalHot += dayperiodViewModel.consumptions
          .firstWhere((c) => c.tag == 'hot')
          .values[i]
          .round();
    }
    return totalHot;
  }

  @override
  void initState() {
    super.initState();
    final dashboardViewModel = context.read<DashboardViewModel>();
    final dayperiodViewModel = context.read<DayPeriodConsumptionViewModel>();
    dashboardViewModel.fetchDailyWaterConsumption(context);
    dashboardViewModel.fetchQuarterWaterConsumption(context);
    dashboardViewModel.fetchInvoices(context);
    dayperiodViewModel.fetchDayPeriodConsumption();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardViewModel = context.watch<DashboardViewModel>();
    final dayperiodViewModel = context.watch<DayPeriodConsumptionViewModel>();

    bool _isLoading = dashboardViewModel.currentWaterConsumption == 0 &&
        dashboardViewModel.quarterWaterConsumption == 0 &&
        dayperiodViewModel.total == 0;

    // Check if the selectedWaterMeterIds list has more than one meter or none
    final waterMetersViewModel = context.watch<WaterMetersViewModel>();
    bool showCircularIndicator =
        waterMetersViewModel.selectedMeterIds.length == 1;

    return Container(
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: MyAppBar(page: AppLocale.Dashboard.getString(context)),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await dashboardViewModel.fetchDailyWaterConsumption(context);
            await dashboardViewModel.fetchQuarterWaterConsumption(context);
            await dashboardViewModel.fetchInvoices(context);
            await dayperiodViewModel.fetchDayPeriodConsumption();
          },
          child: Skeletonizer(
            enabled: _isLoading,
            ignoreContainers: true,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Positioned(
                      top: 25,
                      right: 30,
                      child: Center(
                        child: Container(
                            child: SfCircularChart(
                          series: <CircularSeries>[
                            DoughnutSeries<ChartData, String>(
                              dataSource: dayperiodViewModel.total == 0
                                  ? [
                                      ChartData('', 100, gray),
                                    ]
                                  : _createSeriesList(dayperiodViewModel),
                              xValueMapper: (ChartData data, _) => data.name,
                              yValueMapper: (ChartData data, _) => data.value,
                              cornerStyle: CornerStyle.bothFlat,
                              radius: '100%',
                              innerRadius: '87%',
                              pointColorMapper: (ChartData data, _) =>
                                  data.color,
                            ),
                          ],
                        )),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 110),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              Text(
                                dayperiodViewModel.total.toStringAsFixed(2) +
                                    ' L',
                                style: TextStyles.Header22Style(
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: blue,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    AppLocale.Froid.getString(context) +
                                        ': ' +
                                        _getColdConsumption(dayperiodViewModel)
                                            .toStringAsFixed(2) +
                                        'L',
                                    style: TextStyles.subtitle6Style(
                                      Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: red,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    AppLocale.Chaud.getString(context) +
                                        ': ' +
                                        _getHotConsumption(dayperiodViewModel)
                                            .toStringAsFixed(2) +
                                        'L',
                                    style: TextStyles.subtitle6Style(
                                      Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 280,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 83),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                top: 70,
                              ),
                              child: Icon(
                                dashboardViewModel.waterConsumptionPercentage
                                        .toString()
                                        .startsWith('-')
                                    ? Icons.arrow_downward_sharp
                                    : Icons.arrow_upward_sharp,
                                color: dashboardViewModel
                                        .waterConsumptionPercentage
                                        .toString()
                                        .startsWith('-')
                                    ? green
                                    : red,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 70),
                              child: Text(
                                dashboardViewModel.waterConsumptionPercentage
                                        .toString() +
                                    '% ' +
                                    AppLocale.Moyenne.getString(context),
                                style: TextStyles.subtitle3Style(
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 385,
                      left: 25,
                      child: SizedBox(
                        width: 340,
                        height: 100,
                        child: Container(
                          margin: EdgeInsets.only(top: 10, right: 7, left: 7),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                AppLocale.Fees.getString(context),
                                style: TextStyles.Header3_Style(
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 21, right: 90),
                                child: Row(
                                  children: [
                                    Text(
                                      AppLocale.FraisT.getString(context),
                                      style: TextStyles.subtitle2Style(
                                        Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      dashboardViewModel.totalAmount
                                              .toStringAsFixed(3) +
                                          ' TND',
                                      style: TextStyles.subtitle2Style(
                                        Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 17, top: 5),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      AppLocale.FraisS.getString(context),
                                      style: TextStyles.subtitle5Style(
                                        Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      dashboardViewModel.sonedeAmount
                                              .toStringAsFixed(3) +
                                          ' TND',
                                      style: TextStyles.subtitle5Style(
                                        Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 19,
                                    ),
                                    Text(
                                      AppLocale.FraisO.getString(context),
                                      style: TextStyles.subtitle5Style(
                                        Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      dashboardViewModel.onasAmount
                                              .toStringAsFixed(3) +
                                          ' TND',
                                      style: TextStyles.subtitle5Style(
                                        Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 490,
                      left: 25,
                      child: SizedBox(
                        width: 340,
                        height: 100,
                        child: Container(
                          margin: EdgeInsets.only(top: 10, right: 7, left: 7),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                AppLocale.ConsommationTrim.getString(context),
                                style: TextStyles.subtitle3Style(
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                    height: 20,
                                  ),
                                  Container(
                                    child: Icon(
                                      dashboardViewModel
                                              .quarterwaterConsumptionPercentage
                                              .toString()
                                              .startsWith('-')
                                          ? Icons.arrow_downward_sharp
                                          : Icons.arrow_upward_sharp,
                                      color: dashboardViewModel
                                              .quarterwaterConsumptionPercentage
                                              .toString()
                                              .startsWith('-')
                                          ? green
                                          : red,
                                      size: 10,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Container(
                                    child: Text(
                                      dashboardViewModel
                                              .quarterwaterConsumptionPercentage
                                              .toString()
                                              .toString() +
                                          '% ' +
                                          AppLocale.Moyenne.getString(context),
                                      style: TextStyles.subtitle4Style(
                                        Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                              Center(
                                child: Text(
                                  dashboardViewModel.quarterWaterConsumption
                                          .toString() +
                                      'L',
                                  style: TextStyles.Header1Style(
                                    Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Conditional rendering of the LiquidCircularProgressIndicator
                    if (showCircularIndicator)
                      Positioned(
                        top: 595,
                        left: 25,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 10, right: 10, left: 10, bottom: 10),
                          child: SizedBox(
                            width: 95,
                            height: 95,
                            child: LiquidCircularProgressIndicator(
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              borderColor: blue,
                              borderWidth: 2,
                              value: dashboardViewModel.consumptionPercentLevel
                                      .toDouble() /
                                  100.0,
                              valueColor: AlwaysStoppedAnimation(blue),
                              center: Text(
                                '  ' +
                                    dashboardViewModel.consumptionPercentLevel
                                        .toInt()
                                        .toString() +
                                    '%\n' +
                                    AppLocale.Level.getString(context) +
                                    ' ' +
                                    dashboardViewModel.consumptionLevel
                                        .toInt()
                                        .toString(),
                                style: TextStyles.palierStyle(
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 595,
                      left: 135,
                      child: SizedBox(
                        width: 230,
                        height: 100,
                        child: Container(
                            margin: EdgeInsets.only(top: 10, right: 7, left: 7),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(9)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: SizedBox(
                                          height: 40,
                                          child: MyTxtBtnNotOutlined(
                                            text:
                                                AppLocale.PlusDetails.getString(
                                                    context),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, '/dashboardplus');
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        '${hourFormat.format(currentTime)} ${amPmFormat.format(currentTime)}',
                                        style: TextStyles.subtitle5Style(
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: Icon(
                                        Icons.bar_chart_sharp,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
