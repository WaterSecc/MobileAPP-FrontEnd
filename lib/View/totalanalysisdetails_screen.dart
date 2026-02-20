import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:watersec_mobileapp_front/ViewModel/analyticsViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/watermeterViewModel.dart';
import 'package:watersec_mobileapp_front/classes/chart_class.dart';
import 'package:watersec_mobileapp_front/classes/consumption.dart';
import 'package:watersec_mobileapp_front/classes/consumption_statsResponse.dart';
import 'package:watersec_mobileapp_front/colors.dart';

class TotalAnalysisDetailsPage extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final List<Map<String, String>>
      selectedTags; // same structure you use in Analyses

  const TotalAnalysisDetailsPage({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.selectedTags,
  });

  @override
  State<TotalAnalysisDetailsPage> createState() =>
      _TotalAnalysisDetailsPageState();
}

class _TotalAnalysisDetailsPageState extends State<TotalAnalysisDetailsPage> {
  bool _loading = true;

  final DateFormat _dformat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetch());
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);

    final analyticsVM = context.read<AnalyticsViewModel>();
    final waterMetersVM = context.read<WaterMetersViewModel>();

    final sensors = widget.selectedTags.map((t) => t['floorId'] ?? '').toList();

    await analyticsVM.fetchAnalyticsData(
      waterMetersViewModel: waterMetersVM,
      startDate: widget.startDate,
      endDate: widget.endDate,
      sensors: sensors,
    );

    if (!mounted) return;
    setState(() => _loading = false);
  }

  // ✅ Same logic as your filter pill: show (start end) unless same day
  String _periodLabel() {
    final s = widget.startDate;
    final e = widget.endDate;
    final sameDay = s.year == e.year && s.month == e.month && s.day == e.day;
    if (sameDay) return _dformat.format(e);
    return '${_dformat.format(s)}  ${_dformat.format(e)}';
  }

  ConsumptionStats _getColdConsumption(AnalyticsViewModel vm) {
    if (vm.analyticsResponse != null &&
        vm.analyticsResponse!.stats.isNotEmpty) {
      return vm.analyticsResponse!.stats.firstWhere(
        (s) => s.tag == 'cold',
        orElse: () => ConsumptionStats(
          tag: 'cold',
          total: 0.0,
          averagePerDay: 0.0,
          averagePerUse: 0.0,
        ),
      );
    }
    return ConsumptionStats(
      tag: 'cold',
      total: 0.0,
      averagePerDay: 0.0,
      averagePerUse: 0.0,
    );
  }

  ConsumptionStats _getHotConsumption(AnalyticsViewModel vm) {
    if (vm.analyticsResponse != null &&
        vm.analyticsResponse!.stats.isNotEmpty) {
      return vm.analyticsResponse!.stats.firstWhere(
        (s) => s.tag == 'hot',
        orElse: () => ConsumptionStats(
          tag: 'hot',
          total: 0.0,
          averagePerDay: 0.0,
          averagePerUse: 0.0,
        ),
      );
    }
    return ConsumptionStats(
      tag: 'hot',
      total: 0.0,
      averagePerDay: 0.0,
      averagePerUse: 0.0,
    );
  }

  List<ChartDataBar> _buildBars(AnalyticsViewModel vm) {
    final res = vm.analyticsResponse;
    final List<ChartDataBar> data = [];

    if (res == null || res.dates.isEmpty || res.consumptions.isEmpty)
      return data;

    final coldValues = res.consumptions
        .firstWhere((c) => c.tag == 'cold',
            orElse: () => Consumption(tag: 'cold', values: []))
        .values;

    final hotValues = res.consumptions
        .firstWhere((c) => c.tag == 'hot',
            orElse: () => Consumption(tag: 'hot', values: []))
        .values;

    for (int i = 0; i < res.dates.length; i++) {
      final coldValue = (i < coldValues.length) ? coldValues[i] : 0.0;
      final hotValue = (i < hotValues.length) ? hotValues[i] : 0.0;
      data.add(ChartDataBar(res.dates[i], coldValue, hotValue));
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.background;
    final fg = Theme.of(context).colorScheme.secondary;

    final analyticsVM = context.watch<AnalyticsViewModel>();
    final res = analyticsVM.analyticsResponse;

    final cold = _getColdConsumption(analyticsVM);
    final hot = _getHotConsumption(analyticsVM);

    final totalLiters = (cold.total + hot.total);

    final avgDayTotal = res?.allAveragePerDay ?? 0.0;
    final avgUseTotal = res?.allAveragePerUse ?? 0.0;

    final bars = _buildBars(analyticsVM);

    // stacked chart series
    final List<CartesianSeries<ChartDataBar, String>> series =
        <CartesianSeries<ChartDataBar, String>>[
      StackedColumnSeries<ChartDataBar, String>(
        name: 'Froid',
        color: newBlue,
        dataSource: bars,
        xValueMapper: (d, _) => d.date,
        yValueMapper: (d, _) => d.coldLiters,
      ),
      StackedColumnSeries<ChartDataBar, String>(
        name: 'Chaud',
        color: newRed,
        dataSource: bars,
        xValueMapper: (d, _) => d.date,
        yValueMapper: (d, _) => d.hotLiters,
      ),
    ];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: fg),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Total Analysis",
          style: TextStyle(color: fg, fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              children: [
                // ✅ Period centered (like your filter button logic)
                Center(
                  child: Text(
                    _periodLabel(),
                    style: TextStyle(
                      color: fg.withOpacity(0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // big liters left
                Text(
                  "${totalLiters.toStringAsFixed(0)}Litres",
                  style: TextStyle(
                    color: fg,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),

                // legend (like screenshot)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LegendDot(
                      color: newBlue,
                      text: "Froid: ${cold.total.toStringAsFixed(3)} Litres",
                      fg: fg,
                    ),
                    const SizedBox(width: 18),
                    _LegendDot(
                      color: newRed,
                      text: "Chaud: ${hot.total.toStringAsFixed(3)} Litres",
                      fg: fg,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: 260,
                  child: SfCartesianChart(
                    backgroundColor: bg,
                    plotAreaBackgroundColor: bg,
                    primaryXAxis: CategoryAxis(
                      labelStyle: TextStyle(
                        color: fg.withOpacity(0.7),
                        fontSize: 10,
                      ),
                      plotOffset: 12,
                      interval: 1,
                    ),
                    primaryYAxis: NumericAxis(
                      labelStyle: TextStyle(
                        color: fg.withOpacity(0.7),
                        fontSize: 10,
                      ),
                      majorGridLines:
                          MajorGridLines(color: fg.withOpacity(0.08)),
                    ),
                    series: series,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: "Average per day",
                        total: avgDayTotal,
                        cold: cold.averagePerDay,
                        hot: hot.averagePerDay,
                        fg: fg,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _StatCard(
                        title: "Average per use",
                        total: avgUseTotal,
                        cold: cold.averagePerUse,
                        hot: hot.averagePerUse,
                        fg: fg,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String text;
  final Color fg;

  const _LegendDot({
    required this.color,
    required this.text,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: fg.withOpacity(0.75),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final double total;
  final double cold;
  final double hot;
  final Color fg;

  const _StatCard({
    required this.title,
    required this.total,
    required this.cold,
    required this.hot,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          _row("Total", "${total.toStringAsFixed(2)} Liters"),
          const SizedBox(height: 8),
          _row("Cold", "${cold.toStringAsFixed(2)} Liters"),
          const SizedBox(height: 8),
          _row("Hot", "${hot.toStringAsFixed(2)} Liters"),
        ],
      ),
    );
  }

  Widget _row(String a, String b) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          a,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        Flexible(
          child: Text(
            b,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
