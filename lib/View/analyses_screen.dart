import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/dateselection_container.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
import 'package:watersec_mobileapp_front/View/custompopup.dart';
import 'package:watersec_mobileapp_front/ViewModel/analyticsViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/watermeterViewModel.dart';
import 'package:watersec_mobileapp_front/classes/chartData.dart';
import 'package:watersec_mobileapp_front/classes/chart_class.dart';
import 'package:watersec_mobileapp_front/classes/consumption.dart';
import 'package:watersec_mobileapp_front/classes/consumption_statsResponse.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class Analyses extends StatefulWidget {
  const Analyses({Key? key}) : super(key: key);

  @override
  State<Analyses> createState() => _AnalysesState();
}

class _AnalysesState extends State<Analyses> {
  late final String _page = AppLocale.Analysis.getString(context);
  List<Map<String, String>> selectedTags = [];
  DateTime? _selectedDate1;
  DateTime? _selectedDate2;
  final DateFormat dformat = DateFormat('dd/MM/yyyy');
  late final CalendarContainer calendarContainer;
  bool _isLoading = true;
  final _analyticsViewModel = AnalyticsViewModel();
  List<Consumption> _consumptions = [];
  List<String> _analyticsdates = [];
  double _allTotal = 0.0;
  double _allAveragePerUse = 0.0;
  double _allAveragePerDay = 0.0;
  List<ConsumptionStats> _stats = [];

  List<ChartSeries<ChartDataBar, String>> _createSeriesChartList(
      AnalyticsViewModel analyticsViewModel) {
    List<ChartDataBar> data = [];

    if (analyticsViewModel.analyticsResponse != null &&
        analyticsViewModel.analyticsResponse!.dates.isNotEmpty &&
        analyticsViewModel.analyticsResponse!.consumptions.isNotEmpty) {
      for (int i = 0;
          i < analyticsViewModel.analyticsResponse!.dates.length;
          i++) {
        double coldValue = analyticsViewModel.analyticsResponse!.consumptions
            .firstWhere((c) => c.tag == 'cold',
                orElse: () => Consumption(tag: 'cold', values: []))
            .values[i];
        double hotValue = analyticsViewModel.analyticsResponse!.consumptions
            .firstWhere((c) => c.tag == 'hot',
                orElse: () => Consumption(tag: 'hot', values: []))
            .values[i];
        data.add(ChartDataBar(
          analyticsViewModel.analyticsResponse!.dates[i],
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

  List<ChartData> _createSeriesList(AnalyticsViewModel analyticsViewModel) {
    double totalCold = 0.0;
    double totalHot = 0.0;

    if (analyticsViewModel.analyticsResponse != null) {
      totalCold = _getColdConsumption(analyticsViewModel).total;
      totalHot = _getHotConsumption(analyticsViewModel).total;
    }

    return [
      ChartData('Hot', totalHot, red),
      ChartData('Cold', totalCold, blue),
    ];
  }

  ConsumptionStats _getColdConsumption(AnalyticsViewModel analyticsViewModel) {
    if (analyticsViewModel.analyticsResponse != null &&
        analyticsViewModel.analyticsResponse!.stats.isNotEmpty) {
      final coldStats = analyticsViewModel.analyticsResponse!.stats.firstWhere(
        (s) => s.tag == 'cold',
        orElse: () => ConsumptionStats(
            tag: 'cold', total: 0.0, averagePerDay: 0.0, averagePerUse: 0.0),
      );
      return coldStats;
    } else {
      return ConsumptionStats(
          tag: 'cold', total: 0.0, averagePerDay: 0.0, averagePerUse: 0.0);
    }
  }

  ConsumptionStats _getHotConsumption(AnalyticsViewModel analyticsViewModel) {
    if (analyticsViewModel.analyticsResponse != null &&
        analyticsViewModel.analyticsResponse!.stats.isNotEmpty) {
      final hotStats = analyticsViewModel.analyticsResponse!.stats.firstWhere(
        (s) => s.tag == 'hot',
        orElse: () => ConsumptionStats(
            tag: 'hot', total: 0.0, averagePerDay: 0.0, averagePerUse: 0.0),
      );
      return hotStats;
    } else {
      return ConsumptionStats(
          tag: 'hot', total: 0.0, averagePerDay: 0.0, averagePerUse: 0.0);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDate1 = DateTime.now();
    _selectedDate2 = DateTime.now().subtract(Duration(days: 30));

    // Use WidgetsBinding to delay accessing the context until the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final analyticsViewModel = context.read<AnalyticsViewModel>();
      _fetchAnalyticsData(analyticsViewModel); // Fetch data here
    });
  }

  Future<void> _fetchAnalyticsData(
      AnalyticsViewModel analyticsViewModel) async {
    // Access WaterMetersViewModel using Provider
    final waterMetersViewModel =
        Provider.of<WaterMetersViewModel>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    // Extract `floorId`s from `selectedTags`:
    List<String> floorIds =
        selectedTags.map((tag) => tag['floorId'] ?? '').toList();

    await analyticsViewModel.fetchAnalyticsData(
      waterMetersViewModel:
          waterMetersViewModel, // Pass the WaterMetersViewModel
      startDate: _selectedDate2,
      endDate: _selectedDate1,
      sensors: floorIds,
    );

    if (analyticsViewModel.analyticsResponse != null) {
      setState(() {
        _isLoading = false;
        _consumptions = analyticsViewModel.analyticsResponse!.consumptions;
        _analyticsdates = analyticsViewModel.analyticsResponse!.dates;
        _allTotal = analyticsViewModel.analyticsResponse!.allTotal;
        _allAveragePerDay =
            analyticsViewModel.analyticsResponse!.allAveragePerDay;
        _allAveragePerUse =
            analyticsViewModel.analyticsResponse!.allAveragePerUse;
        _stats = analyticsViewModel.analyticsResponse!.stats;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onFiltersAndDatesSelected(List<Map<String, String>> selectedFloors,
      DateTime startDate, DateTime endDate) {
    List<String> floorIds =
        selectedFloors.map((floor) => floor['floorId'] ?? '').toList();

    setState(() {
      _selectedDate1 = endDate;
      _selectedDate2 = startDate;
      selectedTags = selectedFloors;
    });

    final analyticsViewModel = context.read<AnalyticsViewModel>();
    _fetchAnalyticsData(analyticsViewModel);
  }

  void _onFiltersSelected(List<Map<String, String>> floorIds) {
    setState(() {
      selectedTags = floorIds;
    });
  }

  // Fetch new data based on the selected water meters
  void _fetchAnalyticsDataOnSelectionChange(
      WaterMetersViewModel waterMetersViewModel) {
    // Extract just the floor IDs from selectedTags
    List<String> floorIds =
        selectedTags.map((tag) => tag['floorId'] ?? '').toList();

    // Pass the list of floor IDs to the analytics view model
    _analyticsViewModel.fetchAnalyticsData(
      waterMetersViewModel: waterMetersViewModel,
      startDate: _selectedDate2,
      endDate: _selectedDate1,
      sensors: floorIds, // Corrected to pass only the floor IDs
    );
  }

  @override
  Widget build(BuildContext context) {
    final waterMetersViewModel = context.watch<WaterMetersViewModel>();
    final analyticsViewModel = context.watch<AnalyticsViewModel>();

    return Consumer<WaterMetersViewModel>(
      builder: (context, waterMetersViewModel, child) {
        // Fetch new analytics data based on selected water meters
        _fetchAnalyticsDataOnSelectionChange(waterMetersViewModel);
        return Container(
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            drawer: MyDrawer(),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: MyAppBar(page: _page),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await _fetchAnalyticsData(analyticsViewModel);
              },
              child: Skeletonizer(
                enabled: _isLoading,
                ignoreContainers: true,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomPopup(
                                  onFiltersAndDatesSelected:
                                      _onFiltersAndDatesSelected,
                                  defaultTagText: 'Default Tag',
                                );
                              },
                            );
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.sliders,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 17,
                                  ),
                                  Text(
                                    '${dformat.format(_selectedDate2 ?? DateTime.now().subtract(Duration(days: 30)))} - ${dformat.format(_selectedDate1 ?? DateTime.now())}',
                                    style: TextStyles.subtitle3Style(
                                      Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    selectedTags.isNotEmpty
                                        ? selectedTags.map((tag) {
                                            String buildingName =
                                                tag['buildingName'] ?? '';
                                            String floorName =
                                                tag['floorName'] ?? '';
                                            return '$buildingName: $floorName'; // Display format
                                          }).join(', ')
                                        : AppLocale.filtrer.getString(context),
                                    style: TextStyles.subtitle4Style(
                                      Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                              Theme.of(context).colorScheme.background,
                            ),
                            shadowColor: MaterialStatePropertyAll<Color>(blue),
                            side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1.3,
                              ),
                            ),
                            fixedSize: MaterialStatePropertyAll(Size(340, 60)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 262,
                                  width: 257,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9)),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(6),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 6),
                                        Text(
                                          AppLocale.ConsommationTotal.getString(
                                              context),
                                          style: TextStyles.subtitle5Style(
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        SizedBox(height: 22),
                                        Text(
                                          analyticsViewModel
                                                  .analyticsResponse?.allTotal
                                                  .toStringAsFixed(2) ??
                                              '0.00 L',
                                          style: TextStyles.Header1Style(
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.only(top: 25, left: 7),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: blue,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Flexible(
                                                child: Text(
                                                  '${AppLocale.Froid.getString(context)}: ${_getColdConsumption(analyticsViewModel).total.toStringAsFixed(2)}L',
                                                  style:
                                                      TextStyles.subtitle6Style(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: red,
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Flexible(
                                                child: Text(
                                                  '${AppLocale.Chaud.getString(context)}: ${_getHotConsumption(analyticsViewModel).total.toStringAsFixed(2)}L',
                                                  style:
                                                      TextStyles.subtitle6Style(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          height: 100,
                                          width: 100,
                                          child: SfCircularChart(
                                            series: <CircularSeries>[
                                              DoughnutSeries<ChartData, String>(
                                                dataSource: _createSeriesList(
                                                    analyticsViewModel),
                                                xValueMapper:
                                                    (ChartData data, _) =>
                                                        data.name,
                                                yValueMapper:
                                                    (ChartData data, _) =>
                                                        data.value,
                                                cornerStyle:
                                                    CornerStyle.bothFlat,
                                                radius: '100%',
                                                innerRadius: '75%',
                                                pointColorMapper:
                                                    (ChartData data, _) =>
                                                        data.color,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Column(
                                  children: [
                                    _buildAverageContainer(
                                      context,
                                      title:
                                          '${AppLocale.Average.getString(context)} ${AppLocale.PerDay.getString(context)}',
                                      value: analyticsViewModel
                                              .analyticsResponse
                                              ?.allAveragePerDay
                                              .toStringAsFixed(2) ??
                                          '0.00 L',
                                      coldValue: _getColdConsumption(
                                              analyticsViewModel)
                                          .averagePerDay
                                          .toStringAsFixed(2),
                                      hotValue:
                                          _getHotConsumption(analyticsViewModel)
                                              .averagePerDay
                                              .toStringAsFixed(2),
                                    ),
                                    SizedBox(height: 10),
                                    _buildAverageContainer(
                                      context,
                                      title:
                                          '${AppLocale.Average.getString(context)} ${AppLocale.PerUse.getString(context)}',
                                      value: analyticsViewModel
                                              .analyticsResponse
                                              ?.allAveragePerUse
                                              .toStringAsFixed(2) ??
                                          '0.00 L',
                                      coldValue: _getColdConsumption(
                                              analyticsViewModel)
                                          .averagePerUse
                                          .toStringAsFixed(2),
                                      hotValue:
                                          _getHotConsumption(analyticsViewModel)
                                              .averagePerUse
                                              .toStringAsFixed(2),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          indent: 30,
                          endIndent: 30,
                          thickness: 1,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 250,
                          child: SfCartesianChart(
                            key: const Key('chart'),
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            plotAreaBackgroundColor:
                                Theme.of(context).colorScheme.background,
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
                              plotOffset: 20,
                            ),
                            series: _createSeriesChartList(analyticsViewModel)
                                .cast<CartesianSeries<ChartDataBar, String>>(),
                            title: ChartTitle(
                              text: AppLocale.Consommation.getString(context) +
                                  ': ' +
                                  AppLocale.periodAnalyses.getString(context),
                              alignment: ChartAlignment.near,
                              textStyle: TextStyles.subtitle3Style(
                                Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _customTooltipTemplate(dynamic data, ChartPoint<dynamic> point,
      ChartSeries<dynamic, dynamic> series, int pointIndex, int seriesIndex) {
    return SizedBox(
      height: 80,
      width: 120,
      child: Container(
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

  Widget _buildAverageContainer(
    BuildContext context, {
    required String title,
    required String value,
    required String coldValue,
    required String hotValue,
  }) {
    return Container(
      height: 128,
      width: 235,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
        ),
        borderRadius: BorderRadius.all(Radius.circular(9)),
      ),
      child: Container(
        margin: EdgeInsets.all(6),
        child: Column(
          children: [
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyles.subtitle5Style(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(height: 6),
            Text(
              value,
              style: TextStyles.Header1Style(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                _buildLegendDot(blue),
                SizedBox(width: 5),
                Flexible(
                  child: Text(
                    '${AppLocale.Froid.getString(context)}: $coldValue L',
                    style: TextStyles.subtitle6Style(
                      Theme.of(context).colorScheme.secondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 10),
                _buildLegendDot(red),
                SizedBox(width: 5),
                Flexible(
                  child: Text(
                    '${AppLocale.Chaud.getString(context)}: $hotValue L',
                    style: TextStyles.subtitle6Style(
                      Theme.of(context).colorScheme.secondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
