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

class ColdAnalysisDetailsPage extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final List<Map<String, String>> selectedTags;

  const ColdAnalysisDetailsPage({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.selectedTags,
  });

  @override
  State<ColdAnalysisDetailsPage> createState() =>
      _ColdAnalysisDetailsPageState();
}

class _ColdAnalysisDetailsPageState extends State<ColdAnalysisDetailsPage> {
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
      waterMetersViewModel: waterMetersVM, // ✅ correct param name
      startDate: widget.startDate,
      endDate: widget.endDate,
      sensors: sensors,
    );

    if (!mounted) return;
    setState(() => _loading = false);
  }

  ConsumptionStats _getCold(AnalyticsViewModel vm) {
    final res = vm.analyticsResponse;
    if (res != null && res.stats.isNotEmpty) {
      return res.stats.firstWhere(
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

  List<ChartDataBar> _buildBarsColdOnly(AnalyticsViewModel vm) {
    final res = vm.analyticsResponse;
    final List<ChartDataBar> data = [];
    if (res == null || res.dates.isEmpty || res.consumptions.isEmpty)
      return data;

    final coldValues = res.consumptions
        .firstWhere((c) => c.tag == 'cold',
            orElse: () => Consumption(tag: 'cold', values: []))
        .values;

    for (int i = 0; i < res.dates.length; i++) {
      final coldValue = (i < coldValues.length) ? coldValues[i] : 0.0;
      // hotLiters set to 0 to keep ChartDataBar constructor usage stable
      data.add(ChartDataBar(res.dates[i], coldValue, 0.0));
    }
    return data;
  }

  String _periodLabel() {
    final s = _dformat.format(widget.startDate);
    final e = _dformat.format(widget.endDate);
    if (s == e) return e;
    return "$s  -  $e";
  }

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.background;
    final fg = Theme.of(context).colorScheme.secondary;

    final analyticsVM = context.watch<AnalyticsViewModel>();
    final cold = _getCold(analyticsVM);

    final bars = _buildBarsColdOnly(analyticsVM);

    final List<CartesianSeries<ChartDataBar, String>> series =
        <CartesianSeries<ChartDataBar, String>>[
      ColumnSeries<ChartDataBar, String>(
        name: 'Froid',
        color: newBlue,
        dataSource: bars,
        xValueMapper: (d, _) => d.date,
        yValueMapper: (d, _) => d.coldLiters,
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
          "Cold Analysis",
          style: TextStyle(color: fg, fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              children: [
                // ✅ show selected period (same logic as filter)
                Center(
                  child: Text(
                    _periodLabel(),
                    style: TextStyle(
                      color: fg.withOpacity(0.9),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 18),

                Text(
                  "${cold.total.toStringAsFixed(0)}Litres",
                  style: TextStyle(
                    color: fg,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LegendDot(
                      color: newBlue,
                      text: "Froid: ${cold.total.toStringAsFixed(3)} Litres",
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
                      labelStyle:
                          TextStyle(color: fg.withOpacity(0.7), fontSize: 10),
                      plotOffset: 12,
                      interval: 1,
                    ),
                    primaryYAxis: NumericAxis(
                      labelStyle:
                          TextStyle(color: fg.withOpacity(0.7), fontSize: 10),
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
                      child: _StatCardSingle(
                        title: "Average per day",
                        value: cold.averagePerDay,
                        fg: fg,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _StatCardSingle(
                        title: "Average per use",
                        value: cold.averagePerUse,
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

class _StatCardSingle extends StatelessWidget {
  final String title;
  final double value;
  final Color fg;

  const _StatCardSingle({
    required this.title,
    required this.value,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Cold",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Flexible(
                child: Text(
                  "${value.toStringAsFixed(2)} Liters",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
