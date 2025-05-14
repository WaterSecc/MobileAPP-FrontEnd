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
    final waterMetersViewModel = context.watch<WaterMetersViewModel>();
    bool showCircularIndicator =
        waterMetersViewModel.selectedMeterIds.length == 1;

    final isLoading =
        dashboardViewModel.isLoading || dayperiodViewModel.isLoading;

    final width = MediaQuery.of(context).size.width;
    final chartSize = width * 0.75;
    final boxWidth = width * 0.85;
    final boxHeight = 110.0;

    return Scaffold(
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
          enabled: isLoading,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: chartSize,
                          height: chartSize,
                          child: SfCircularChart(
                            margin: EdgeInsets.zero,
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
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "${dayperiodViewModel.total.toStringAsFixed(2)} L",
                              style: TextStyles.Header22Style(
                                Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildIndicator(blue,
                                    "${AppLocale.Froid.getString(context)}: ${_getColdConsumption(dayperiodViewModel)
                                            .toStringAsFixed(2)}L"),
                                SizedBox(width: 15),
                                _buildIndicator(red,
                                    "${AppLocale.Chaud.getString(context)}: ${_getHotConsumption(dayperiodViewModel)
                                            .toStringAsFixed(2)}L"),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        dashboardViewModel.waterConsumptionPercentage < 0
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: dashboardViewModel.waterConsumptionPercentage < 0
                            ? green
                            : red,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "${dashboardViewModel.waterConsumptionPercentage.toStringAsFixed(1)}% ${AppLocale.Moyenne.getString(context)}",
                        style: TextStyles.subtitle3Style(
                          Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildBox(
                    width: boxWidth,
                    height: boxHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            AppLocale.Fees.getString(context),
                            style: TextStyles.Header3_Style(
                                Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Total: ${dashboardViewModel.totalAmount.toStringAsFixed(2)} TND",
                          style: TextStyles.subtitle2Style(
                            Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "SONEDE: ${dashboardViewModel.sonedeAmount.toStringAsFixed(2)} TND",
                              style: TextStyles.subtitle5Style(
                                Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "ONAS: ${dashboardViewModel.onasAmount.toStringAsFixed(2)} TND",
                              style: TextStyles.subtitle5Style(
                                Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildBox(
                    width: boxWidth,
                    height: boxHeight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocale.ConsommationTrim.getString(context),
                          style: TextStyles.subtitle3Style(
                              Theme.of(context).colorScheme.secondary),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              dashboardViewModel
                                          .quarterwaterConsumptionPercentage <
                                      0
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              size: 14,
                              color: dashboardViewModel
                                          .quarterwaterConsumptionPercentage <
                                      0
                                  ? green
                                  : red,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "${dashboardViewModel.quarterwaterConsumptionPercentage.toStringAsFixed(1)}% ${AppLocale.Moyenne.getString(context)}",
                              style: TextStyles.subtitle4Style(
                                  Theme.of(context).colorScheme.secondary),
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            "${dashboardViewModel.quarterWaterConsumption.toStringAsFixed(2)} L",
                            style: TextStyles.Header1Style(
                                Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      if (showCircularIndicator)
                        SizedBox(
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
                      SizedBox(width: 12),
                      _buildBox(
                        width: width * 0.57,
                        height: boxHeight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: MyTxtBtnNotOutlined(
                                text: AppLocale.PlusDetails.getString(context),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/dashboardplus');
                                },
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${hourFormat.format(currentTime)} ${amPmFormat.format(currentTime)}",
                                  style: TextStyles.subtitle5Style(
                                    Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                Icon(
                                  Icons.bar_chart_sharp,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBox(
      {required double width, required double height, required Widget child}) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildIndicator(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyles.subtitle6Style(
            Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
