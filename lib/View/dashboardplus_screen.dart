import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/date_navbutton.dart';
import 'package:watersec_mobileapp_front/ViewModel/analyticsViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/dashboardViewModel.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';
import 'package:provider/provider.dart';

class DashPlus extends StatefulWidget {
  const DashPlus({super.key});

  @override
  State<DashPlus> createState() => _DashPlusState();
}

class _DashPlusState extends State<DashPlus> {
  bool _isLoading = true;
  bool _errorLoadingData = false; // Track if an error occurred
  DateTime? _selectedDate1;
  DateTime? _selectedDate2;
  final _dashboardViewModel = DashboardViewModel();

  // Variables to store the average per day for hot and cold tags
  double _coldAveragePerDay = 0.0;
  double _hotAveragePerDay = 0.0;
  String _consumptionComparison = '';

  @override
  void initState() {
    super.initState();
    _selectedDate1 = DateTime.now();
    _selectedDate2 = DateTime.now().subtract(Duration(days: 30));
    _loadData(); // Combined data loading
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorLoadingData = false;
    });
    try {
      await _fetchData();
      await _fetchDataAverage();
    } catch (error) {
      print("Error loading data: $error");
      setState(() {
        _errorLoadingData = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchData() async {
    print("Fetching daily water consumption data...");
    await _dashboardViewModel.fetchDailyWaterConsumption(context);
    print("Daily water consumption data fetched successfully.");
  }

  Future<void> _fetchDataAverage() async {
    print("Fetching analytics data...");
    final analyticsViewModel =
        Provider.of<AnalyticsViewModel>(context, listen: false);

    // Fetch analytics data
    await analyticsViewModel.fetchAnalyticsData(
      waterMetersViewModel: Provider.of(context, listen: false),
      startDate: _selectedDate2,
      endDate: _selectedDate1,
    );

    // Retrieve stats from AnalyticsViewModel
    final stats = analyticsViewModel.analyticsResponse?.stats ?? [];
    _updateAverages(stats);
    print("Analytics data fetched successfully.");
  }

  void _updateAverages(List<dynamic> stats) {
    for (var stat in stats) {
      if (stat.tag == 'hot') {
        _hotAveragePerDay = stat.averagePerDay;
      } else if (stat.tag == 'cold') {
        _coldAveragePerDay = stat.averagePerDay;
      }
    }

    if (_hotAveragePerDay > _coldAveragePerDay) {
      double difference = _hotAveragePerDay - _coldAveragePerDay;
      _consumptionComparison = AppLocale.DashPlus1Hot.getString(context) +
          ' ${difference.toStringAsFixed(2)} ' +
          AppLocale.DashPlus1L.getString(context) +
          '.';
    } else if (_coldAveragePerDay > _hotAveragePerDay) {
      double difference = _coldAveragePerDay - _hotAveragePerDay;
      _consumptionComparison = AppLocale.DashPlus1Hot.getString(context) +
          ' ${difference.toStringAsFixed(2)} ' +
          AppLocale.DashPlus1L.getString(context) +
          '.';
    } else {
      _consumptionComparison = AppLocale.DashPlus1Equal.getString(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    late double todayconsumptionpercentage;
    double todayConsumption = _dashboardViewModel.currentWaterConsumption;
    double averageConsumptionPercentage =
        _dashboardViewModel.waterConsumptionPercentage;
    String averageconsumptionpercentageString =
        averageConsumptionPercentage.toString();
    String averageconsumptionpercentageStringPositive =
        averageconsumptionpercentageString.replaceAll("-", "");
    double percentagetodouble =
        double.parse(averageconsumptionpercentageStringPositive);

    averageConsumptionPercentage.toString().startsWith('-')
        ? todayconsumptionpercentage = percentagetodouble
        : todayconsumptionpercentage = 100 + averageConsumptionPercentage;

    double averageConsumption = todayConsumption *
        100 /
        (todayconsumptionpercentage); // Calculate average consumption
    double average2 = double.parse(averageConsumption.toStringAsFixed(2));

    double difference = todayConsumption - averageConsumption;
    String differenceText = difference > 0
        ? AppLocale.DashPlus2Above.getString(context) +
            ' ${difference.toStringAsFixed(2)} L'
        : AppLocale.DashPlus2Below.getString(context) +
            ' ${difference.abs().toStringAsFixed(2)} L';

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondary,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          children: [
            SizedBox(
              width: 15,
            ),
            Text(
              AppLocale.Consommation.getString(context),
              style: TextStyles.appBarHeaderStyle(
                Theme.of(context).colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      body: Skeletonizer(
        enabled: _isLoading,
        ignoreContainers: true,
        child: _errorLoadingData
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error loading data", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: Text("Retry"),
                    )
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    DateNavigationButton(),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Text(
                          AppLocale.Highlights.getString(context),
                          style: TextStyles.subtitle2Style(
                            Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    _buildConsumptionComparisonCard(
                        differenceText, average2, todayConsumption),
                    SizedBox(height: 5),
                    _buildAverageComparisonChart(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildConsumptionComparisonCard(
      String differenceText, double average2, double todayConsumption) {
    return Container(
      width: 350,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
        ),
        borderRadius: BorderRadius.all(Radius.circular(9)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child:
                Text(AppLocale.SOfar.getString(context) + ' $differenceText'),
          ),
          SizedBox(
            width: 350,
            height: 150,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries>[
                LineSeries<ChartData, String>(
                  dataSource: [
                    ChartData(AppLocale.Average.getString(context), average2),
                    ChartData(
                        AppLocale.Today.getString(context), todayConsumption),
                  ],
                  xValueMapper: (ChartData data, _) => data.day,
                  yValueMapper: (ChartData data, _) => data.consumption,
                  name: AppLocale.Consommation.getString(context),
                  color: Theme.of(context).colorScheme.secondary,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    color: Theme.of(context).colorScheme.secondary,
                    shape: DataMarkerType.circle,
                  ),
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAverageComparisonChart() {
    return Container(
      width: 350,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
        ),
        borderRadius: BorderRadius.all(Radius.circular(9)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              _consumptionComparison,
              style: TextStyles.subtitle5Style(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <BubbleSeries<ChartData2, String>>[
              BubbleSeries<ChartData2, String>(
                dataSource: [
                  ChartData2(
                      AppLocale.Froid.getString(context), _coldAveragePerDay,
                      size: 20)
                ],
                xValueMapper: (ChartData2 data, _) => data.day,
                yValueMapper: (ChartData2 data, _) => data.consumption,
                sizeValueMapper: (ChartData2 data, _) =>
                    data.size, // Set size for bubble
                name: AppLocale.Froid.getString(context),
                color: blue,
              ),
              BubbleSeries<ChartData2, String>(
                dataSource: [
                  ChartData2(
                      AppLocale.Chaud.getString(context), _hotAveragePerDay,
                      size: 20)
                ],
                xValueMapper: (ChartData2 data, _) => data.day,
                yValueMapper: (ChartData2 data, _) => data.consumption,
                sizeValueMapper: (ChartData2 data, _) => data.size,
                name: AppLocale.Chaud.getString(context),
                color: red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String day;
  final double consumption;

  ChartData(this.day, this.consumption);
}

class ChartData2 {
  final String day;
  final double consumption;
  final double size; // Bubble size

  ChartData2(this.day, this.consumption, {this.size = 15});
}
