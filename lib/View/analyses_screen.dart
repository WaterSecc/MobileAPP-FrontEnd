import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/analysis_calendar_screen.dart';
import 'package:watersec_mobileapp_front/View/coldanalysisdetails_screen.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/bottom_drawer.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
import 'package:watersec_mobileapp_front/View/customFilterpopup.dart';
import 'package:watersec_mobileapp_front/View/hotanalysisdetails_screen.dart';
import 'package:watersec_mobileapp_front/View/totalanalysisdetails_screen.dart';
import 'package:watersec_mobileapp_front/ViewModel/analyticsViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/watermeterViewModel.dart';
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
  List<Map<String, String>> selectedTags = [];
  DateTime? _selectedDate1; // end
  DateTime? _selectedDate2; // start
  final DateFormat dformat = DateFormat('dd/MM/yyyy');

  bool _isLoading = true;

  // ✅ tune this (or replace with a value coming from your backend/config)
  static const double _gaugeThreshold = 1000.0; // liters per "lap"

  @override
  void initState() {
    super.initState();
    _selectedDate1 = DateTime.now();
    _selectedDate2 = DateTime.now().subtract(const Duration(days: 30));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final analyticsViewModel = context.read<AnalyticsViewModel>();
      _fetchAnalyticsData(analyticsViewModel);
    });
  }

  Future<void> _fetchAnalyticsData(
      AnalyticsViewModel analyticsViewModel) async {
    final waterMetersViewModel =
        Provider.of<WaterMetersViewModel>(context, listen: false);

    setState(() => _isLoading = true);

    final sensors = selectedTags.map((t) => t['floorId'] ?? '').toList();

    await analyticsViewModel.fetchAnalyticsData(
      waterMetersViewModel: waterMetersViewModel,
      startDate: _selectedDate2,
      endDate: _selectedDate1,
      sensors: sensors,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _onFiltersAndDatesSelected(
    List<Map<String, String>> selectedFloors,
    DateTime startDate,
    DateTime endDate,
  ) {
    setState(() {
      _selectedDate1 = endDate;
      _selectedDate2 = startDate;
      selectedTags = selectedFloors;
    });

    final analyticsViewModel = context.read<AnalyticsViewModel>();
    _fetchAnalyticsData(analyticsViewModel);
  }

  void _openDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TotalAnalysisDetailsPage(
          startDate: _selectedDate2 ??
              DateTime.now().subtract(const Duration(days: 30)),
          endDate: _selectedDate1 ?? DateTime.now(),
          selectedTags: selectedTags,
        ),
      ),
    );
  }

  void _openColdDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ColdAnalysisDetailsPage(
          startDate: _selectedDate2 ??
              DateTime.now().subtract(const Duration(days: 30)),
          endDate: _selectedDate1 ?? DateTime.now(),
          selectedTags: selectedTags,
        ),
      ),
    );
  }

  void _openHotDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HotAnalysisDetailsPage(
          startDate: _selectedDate2 ??
              DateTime.now().subtract(const Duration(days: 30)),
          endDate: _selectedDate1 ?? DateTime.now(),
          selectedTags: selectedTags,
        ),
      ),
    );
  }

  // --- helpers from your original logic ---
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

  List<ChartSeries<ChartDataBar, String>> _createSeriesChartList(
      AnalyticsViewModel vm) {
    final List<ChartDataBar> data = [];

    if (vm.analyticsResponse != null &&
        vm.analyticsResponse!.dates.isNotEmpty &&
        vm.analyticsResponse!.consumptions.isNotEmpty) {
      for (int i = 0; i < vm.analyticsResponse!.dates.length; i++) {
        final coldValues = vm.analyticsResponse!.consumptions
            .firstWhere((c) => c.tag == 'cold',
                orElse: () => Consumption(tag: 'cold', values: []))
            .values;

        final hotValues = vm.analyticsResponse!.consumptions
            .firstWhere((c) => c.tag == 'hot',
                orElse: () => Consumption(tag: 'hot', values: []))
            .values;

        final coldValue = (i < coldValues.length) ? coldValues[i] : 0.0;
        final hotValue = (i < hotValues.length) ? hotValues[i] : 0.0;

        data.add(
            ChartDataBar(vm.analyticsResponse!.dates[i], coldValue, hotValue));
      }
    }

    return [
      ColumnSeries<ChartDataBar, String>(
        name: 'Cold',
        color: newBlue,
        dataSource: data,
        xValueMapper: (d, _) => d.date,
        yValueMapper: (d, _) => d.coldLiters,
      ),
      ColumnSeries<ChartDataBar, String>(
        name: 'Hot',
        color: newRed,
        dataSource: data,
        xValueMapper: (d, _) => d.date,
        yValueMapper: (d, _) => d.hotLiters,
      ),
    ];
  }

  String _filterSubtitle(BuildContext context) {
    if (selectedTags.isEmpty) return AppLocale.filtrer.getString(context);
    return selectedTags.map((tag) {
      final building = tag['buildingName'] ?? '';
      final floor = tag['floorName'] ?? '';
      final txt = '$building: $floor'.trim();
      return txt.isEmpty ? '-' : txt;
    }).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final analyticsViewModel = context.watch<AnalyticsViewModel>();
    final res = analyticsViewModel.analyticsResponse;

    final cold = _getColdConsumption(analyticsViewModel);
    final hot = _getHotConsumption(analyticsViewModel);

    final allTotal = res?.allTotal ?? 0.0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      endDrawer: ProfileEndDrawer(
        onProfileTap: () => Navigator.pushReplacementNamed(context, '/profile'),
        onLogout: () => Navigator.pushReplacementNamed(context, '/login'),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(
          title: AppLocale.Analysis.getString(context),
        ),
      ),
      bottomNavigationBar: const MyBottomNav(currentIndex: 1),
      body: RefreshIndicator(
        onRefresh: () =>
            _fetchAnalyticsData(context.read<AnalyticsViewModel>()),
        child: Skeletonizer(
          enabled: _isLoading,
          ignoreContainers: true,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final scale = (w / 390.0).clamp(0.9, 1.15);
              double sz(double v) => v * scale;

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(sz(18), sz(14), sz(18), sz(18)),
                children: [
                  Center(
                    child: SizedBox(
                      width: sz(280),
                      height: sz(160),
                      // ✅ FIXED: use the new _SemiGauge signature
                      child: _SemiGauge(
                        coldValue: cold.total,
                        hotValue: hot.total,
                        threshold: _gaugeThreshold,
                        coldColor: newBlue,
                        hotColor: newRed,
                        backgroundTrack: Colors.transparent,
                      ),
                    ),
                  ),
                  SizedBox(height: sz(16)),
                  _newBlueFilterCard(
                    height: sz(72),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AnalysisCalendarPage(
                            onFiltersAndDatesSelected:
                                _onFiltersAndDatesSelected,
                          ),
                        ),
                      );
                    },
                    title:
                        '${dformat.format(_selectedDate2 ?? DateTime.now().subtract(const Duration(days: 30)))}  ${dformat.format(_selectedDate1 ?? DateTime.now())}',
                    subtitle: _filterSubtitle(context),
                    scale: scale,
                  ),
                  SizedBox(height: sz(18)),
                  _StatsTripleCard(
                    scale: scale,
                    total: allTotal,
                    cold: cold.total,
                    hot: hot.total,
                    onTotalTap: _openDetails,
                    onColdTap: _openColdDetails,
                    onHotTap: _openHotDetails,
                  ),
                  SizedBox(height: sz(18)),
                  _InfoCard(
                    scale: scale,
                    title: "CSR Insights",
                    body: "some csr insight text",
                  ),
                  SizedBox(height: sz(18)),
                  _InfoCard(
                    scale: scale,
                    title: "Smart Recommendations",
                    body: "some text on how to save water in a smart building",
                  ),
                  SizedBox(height: sz(18)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _customTooltipTemplate(dynamic data, ChartPoint<dynamic> point,
      ChartSeries<dynamic, dynamic> series, int pointIndex, int seriesIndex) {
    return const SizedBox.shrink();
  }
}

// ===================== UI WIDGETS =====================

class _SemiGauge extends StatelessWidget {
  // values in liters (or your unit)
  final double coldValue;
  final double hotValue;

  // threshold for ONE half-gauge lap (same unit as values)
  final double threshold;

  // colors / style
  final Color coldColor; // newBlue
  final Color hotColor; // newRed
  final Color backgroundTrack;

  const _SemiGauge({
    required this.coldValue,
    required this.hotValue,
    required this.threshold,
    required this.coldColor,
    required this.hotColor,
    required this.backgroundTrack,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SemiGaugePainter(
        coldValue: coldValue,
        hotValue: hotValue,
        threshold: threshold <= 0 ? 1 : threshold,
        coldColor: coldColor,
        hotColor: hotColor,
        backgroundTrack: backgroundTrack,
      ),
    );
  }
}

class _SemiGaugePainter extends CustomPainter {
  final double coldValue;
  final double hotValue;
  final double threshold;

  final Color coldColor;
  final Color hotColor;
  final Color backgroundTrack;

  _SemiGaugePainter({
    required this.coldValue,
    required this.hotValue,
    required this.threshold,
    required this.coldColor,
    required this.hotColor,
    required this.backgroundTrack,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = math.min(size.width / 2, size.height) * 0.95;

    final outerStroke = radius * 0.18;
    final innerStroke = radius * 0.16;
    final innerRadius = radius * 0.76;

    final rectOuter = Rect.fromCircle(center: center, radius: radius);
    final rectInner = Rect.fromCircle(center: center, radius: innerRadius);

    final total = (coldValue + hotValue);
    final hasData = total > 0.000001;

    // ✅ base (under) colors: show rainbow even if empty
    final baseAlpha = hasData ? 0.22 : 0.16; // tweak if you want
    final coldBase = coldColor.withValues(alpha: baseAlpha);
    final hotBase = hotColor.withValues(alpha: baseAlpha);

    // ✅ progress colors: stronger when data exists, softer when empty
    final progAlpha = hasData ? 1.0 : 0.35;
    final coldProg = coldColor.withValues(alpha: progAlpha);
    final hotProg = hotColor.withValues(alpha: progAlpha);

    // wrap logic
    final laps = hasData ? (total / threshold).floor() : 0;
    final remainder = hasData ? (total % threshold) : 0.0;
    final lapProgress = hasData ? (remainder / threshold).clamp(0.0, 1.0) : 0.0;

    // split current lap progress between cold/hot by share
    final coldShare = hasData ? (coldValue / total).clamp(0.0, 1.0) : 0.0;
    final hotShare = hasData ? (hotValue / total).clamp(0.0, 1.0) : 0.0;

    final coldLapProgress = (lapProgress * coldShare).clamp(0.0, 1.0);
    final hotLapProgress = (lapProgress * hotShare).clamp(0.0, 1.0);

    // ✅ DRAW BASE RAINBOW (FULL LENGTH) — no gray track
    final coldBasePaint = Paint()
      ..color = coldBase
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerStroke
      ..strokeCap = StrokeCap.butt;

    final hotBasePaint = Paint()
      ..color = hotBase
      ..style = PaintingStyle.stroke
      ..strokeWidth = innerStroke
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(rectOuter, math.pi, math.pi, false, coldBasePaint);
    canvas.drawArc(rectInner, math.pi, math.pi, false, hotBasePaint);

    // ✅ DRAW PROGRESS ON TOP
    final coldProgPaint = Paint()
      ..color = coldProg
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerStroke
      ..strokeCap = StrokeCap.butt;

    final hotProgPaint = Paint()
      ..color = hotProg
      ..style = PaintingStyle.stroke
      ..strokeWidth = innerStroke
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
        rectOuter, math.pi, math.pi * coldLapProgress, false, coldProgPaint);
    canvas.drawArc(
        rectInner, math.pi, math.pi * hotLapProgress, false, hotProgPaint);

    // wrap indicator
    if (laps >= 1 && hasData) {
      _drawWrapIndicator(
        canvas: canvas,
        center: center,
        radius: radius,
        laps: laps,
      );
    }
  }

  void _drawWrapIndicator({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required int laps,
  }) {
    final badgeW = radius * 0.42;
    final badgeH = radius * 0.22;

    final badgeRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + radius * 0.92, center.dy - radius * 0.35),
        width: badgeW,
        height: badgeH,
      ),
      Radius.circular(badgeH / 2),
    );

    final badgePaint = Paint()..color = Colors.black.withValues(alpha: 0.25);
    canvas.drawRRect(badgeRect, badgePaint);

    // icon
    final iconCenter = Offset(
      badgeRect.left + badgeH * 0.55,
      badgeRect.top + badgeH / 2,
    );

    final iconR = badgeH * 0.22;
    final iconPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawArc(
      Rect.fromCircle(center: iconCenter, radius: iconR),
      -math.pi * 0.15,
      math.pi * 1.2,
      false,
      iconPaint,
    );

    final arrowHead = Path()
      ..moveTo(iconCenter.dx + iconR, iconCenter.dy - iconR * 0.55)
      ..lineTo(iconCenter.dx + iconR + iconR * 0.55 * 0.7, iconCenter.dy)
      ..lineTo(iconCenter.dx + iconR, iconCenter.dy + iconR * 0.55);

    final arrowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;

    canvas.drawPath(arrowHead, arrowPaint);

    // xN text
    final textSpan = TextSpan(
      text: 'x$laps',
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.95),
        fontWeight: FontWeight.w800,
        fontSize: badgeH * 0.48,
      ),
    );

    final tp = TextPainter(
      text: textSpan,
      textAlign: TextAlign.left,
      textDirection: ui.TextDirection.ltr, // ✅ FIXED
    )..layout(maxWidth: badgeW);

    tp.paint(
      canvas,
      Offset(
        badgeRect.left + badgeH * 1.05,
        badgeRect.top + (badgeH - tp.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _SemiGaugePainter oldDelegate) {
    return oldDelegate.coldValue != coldValue ||
        oldDelegate.hotValue != hotValue ||
        oldDelegate.threshold != threshold ||
        oldDelegate.coldColor != coldColor ||
        oldDelegate.hotColor != hotColor ||
        oldDelegate.backgroundTrack != backgroundTrack;
  }
}

class _newBlueFilterCard extends StatelessWidget {
  final double height;
  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final double scale;

  const _newBlueFilterCard({
    required this.height,
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    double sz(double v) => v * scale;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(sz(18)),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: sz(16), vertical: sz(10)),
        decoration: BoxDecoration(
          color: newBlue,
          borderRadius: BorderRadius.circular(sz(18)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: white,
                fontSize: sz(20),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: sz(4)),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: white.withValues(alpha: 0.95),
                fontSize: sz(13),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsTripleCard extends StatelessWidget {
  final double scale;
  final double total;
  final double cold;
  final double hot;

  final VoidCallback? onTotalTap;
  final VoidCallback? onColdTap;
  final VoidCallback? onHotTap;

  const _StatsTripleCard({
    required this.scale,
    required this.total,
    required this.cold,
    required this.hot,
    this.onTotalTap,
    this.onColdTap,
    this.onHotTap,
  });

  @override
  Widget build(BuildContext context) {
    double sz(double v) => v * scale;

    Widget col({
      required String label,
      required String value,
      VoidCallback? onArrowTap,
    }) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: sz(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: sz(16),
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onArrowTap,
                    borderRadius: BorderRadius.circular(999),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: sz(14),
                        color: onArrowTap == null
                            ? Colors.black.withValues(alpha: 0.25)
                            : Colors.black.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: sz(6)),
              Text(
                value,
                style: TextStyle(
                  fontSize: sz(14),
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                "/average",
                style: TextStyle(
                  fontSize: sz(12),
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: sz(14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sz(14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          col(
            label: "Total",
            value: "${total.toStringAsFixed(2)} Liters",
            onArrowTap: onTotalTap,
          ),
          col(
            label: "Cold",
            value: "${cold.toStringAsFixed(2)} Liters",
            onArrowTap: onColdTap,
          ),
          col(
            label: "Hot",
            value: "${hot.toStringAsFixed(2)} Liters",
            onArrowTap: onHotTap,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final double scale;
  final String title;
  final String body;

  const _InfoCard({
    required this.scale,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    double sz(double v) => v * scale;

    return Container(
      padding: EdgeInsets.all(sz(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sz(14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
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
            style: TextStyle(
              fontSize: sz(22),
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: sz(10)),
          Text(
            body,
            style: TextStyle(
              fontSize: sz(14),
              fontWeight: FontWeight.w500,
              color: Colors.black.withValues(alpha: 0.65),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
