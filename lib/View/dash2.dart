import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/bottom_drawer.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
import 'package:watersec_mobileapp_front/View/threshold_screen.dart';
import 'package:watersec_mobileapp_front/View/components/animated_dashCards.dart';

import 'package:watersec_mobileapp_front/ViewModel/DashboardViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/day_periodConsumptionViewModel.dart';

import 'package:watersec_mobileapp_front/colors.dart';

class Dashboard2 extends StatefulWidget {
  const Dashboard2({Key? key}) : super(key: key);

  @override
  State<Dashboard2> createState() => _Dashboard2State();
}

class _Dashboard2State extends State<Dashboard2> {
  int _currentThreshold = 0;

  @override
  void initState() {
    super.initState();
    final dashboardVM = context.read<DashboardViewModel>();
    final dayVM = context.read<DayPeriodConsumptionViewModel>();

    dashboardVM.fetchDailyWaterConsumption(context);
    dashboardVM.fetchQuarterWaterConsumption(context);
    dashboardVM.fetchInvoices(context);
    dayVM.fetchDayPeriodConsumption();
  }

  Future<void> _openThresholdSheet() async {
    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: ThresholdScreen(currentThreshold: _currentThreshold),
      ),
    );

    if (result != null) {
      setState(() => _currentThreshold = result);
    }
  }

  void _goToMoreDetails() => Navigator.pushNamed(context, '/dashboardplus');

  @override
  Widget build(BuildContext context) {
    final dashboardVM = context.watch<DashboardViewModel>();
    final dayVM = context.watch<DayPeriodConsumptionViewModel>();
    final bool isLoading = dashboardVM.isLoading || dayVM.isLoading;

    final double totalToday = (dayVM.total).toDouble();
    final double goal = _currentThreshold.toDouble();
    final double fill = (goal <= 0) ? 0.0 : (totalToday / goal).clamp(0.0, 1.0);
    final double pctVsAvg = dashboardVM.waterConsumptionPercentage;

    return Scaffold(
      // keep your appbar logic
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: const MyAppBar(isHome: true),
      ),
      endDrawer: ProfileEndDrawer(
        onProfileTap: () => Navigator.pushReplacementNamed(context, '/profile'),
        onLogout: () => Navigator.pushReplacementNamed(context, '/login'),
      ),
      bottomNavigationBar: const MyBottomNav(currentIndex: 0),

      // IMPORTANT: keep a neutral scaffold bg, we draw the blue inside body
      backgroundColor: Theme.of(context).colorScheme.background,

      body: RefreshIndicator(
        onRefresh: () async {
          await dashboardVM.fetchDailyWaterConsumption(context);
          await dashboardVM.fetchQuarterWaterConsumption(context);
          await dashboardVM.fetchInvoices(context);
          await dayVM.fetchDayPeriodConsumption();
        },
        child: Skeletonizer(
          enabled: isLoading,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;

              final scale = (w / 390.0).clamp(0.85, 1.15);
              double sp(double v) => v * scale;
              double sz(double v) => v * scale;

              // ring bigger + lower
              final ringSize = (w * 0.86).clamp(sz(290), sz(400));
              final ringTop = (h * 0.13).clamp(sz(90), sz(170));
              final ringBottom = ringTop + ringSize;

              // cards sizing + spacing
              final cardH = sz(150);
              final gap = sz(10);

              // keep ~5px above bottom nav
              final bottomSafe = MediaQuery.of(context).padding.bottom;
              final cardsBottom = (5.0 * scale) + bottomSafe;

              // cards close to ring
              final double desiredGapBelowRing = sz(60);
              final cardsTopFromRing = ringBottom + desiredGapBelowRing;

              final cardsTopFromBottom = h - cardsBottom - cardH;

              // closest to ring but never go below bottom constraint
              final cardsTop = cardsTopFromRing.clamp(0.0, cardsTopFromBottom);

              final needsExtraHeight = cardsTopFromRing > cardsTopFromBottom;

              // ✅ BLUE HEADER HEIGHT (covers ring area + a little padding)
              final headerHeight = (ringTop + ringSize + sz(70)).clamp(
                sz(320),
                h * 0.70,
              );

              // content stack
              final content = Stack(
                children: [
                  // ===== BLUE HEADER BACKGROUND WITH CURVE =====
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ClipPath(
                      clipper: _TopCircularClipper(),
                      child: Container(
                        height: headerHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              newBlue,
                              newBlue.withOpacity(0.92),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ===== BIG RING (clickable) =====
                  Positioned(
                    top: ringTop,
                    left: (w - ringSize) / 2,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: _goToMoreDetails,
                      child: SizedBox(
                        width: ringSize,
                        height: ringSize,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: ringSize,
                              height: ringSize,
                              child: CircularProgressIndicator(
                                value: fill,
                                strokeWidth: sz(18),
                                backgroundColor: Colors.white.withOpacity(0.22),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  // slightly lighter arc like the mock
                                  Colors.cyanAccent.withOpacity(0.85),
                                ),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  totalToday.toStringAsFixed(0),
                                  style: TextStyle(
                                    fontSize: sp(56),
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: sz(2)),
                                Text(
                                  "L",
                                  style: TextStyle(
                                    fontSize: sp(18),
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white.withOpacity(0.95),
                                  ),
                                ),
                                SizedBox(height: sz(10)),
                                Text(
                                  goal > 0
                                      ? "/ ${goal.toStringAsFixed(0)} L Goal"
                                      : "/ -- L Goal",
                                  style: TextStyle(
                                    fontSize: sp(14),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white.withOpacity(0.80),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ===== Cards (on white area) =====
                  Positioned(
                    top: cardsTop,
                    left: sz(18),
                    right: sz(18),
                    child: Row(
                      children: [
                        Expanded(
                          child: MiniWaterCardAnimated(
                            height: cardH,
                            fill: (dashboardVM.totalAmount / 50.0)
                                .clamp(0.05, 1.0),
                            title:
                                "${dashboardVM.totalAmount.toStringAsFixed(2)} TND",
                            subtitle1:
                                "SONEDE ${dashboardVM.sonedeAmount.toStringAsFixed(0)} •",
                            subtitle2:
                                "ONAS ${dashboardVM.onasAmount.toStringAsFixed(0)}",
                            leadingIcon: Icons.calendar_month,
                            scale: scale,
                          ),
                        ),
                        SizedBox(width: gap),
                        Expanded(
                          child: MiniWaterCardAnimated(
                            height: cardH,
                            fill: (pctVsAvg.abs() / 100.0).clamp(0.05, 1.0),
                            title: "${pctVsAvg.toStringAsFixed(0)}%",
                            subtitle1: pctVsAvg < 0 ? "Less than" : "More than",
                            subtitle2: "yesterday",
                            trailingIconColor: pctVsAvg < 0 ? green : red,
                            scale: scale,
                          ),
                        ),
                        SizedBox(width: gap),
                        Expanded(
                          child: MiniWaterCardAnimated(
                            height: cardH,
                            fill: fill.clamp(0.05, 1.0),
                            title:
                                goal <= 0 ? "--" : "${goal.toStringAsFixed(0)}",
                            subtitle1: "Daily Goal",
                            subtitle2: "",
                            leadingIcon: Icons.flag_outlined,
                            scale: scale,
                            onTap: _openThresholdSheet,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              // ✅ Always scrollable so RefreshIndicator works even when content doesn't overflow
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: needsExtraHeight ? (h + sz(140)) : h,
                  child: content,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TopCircularClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start top-left
    path.lineTo(0, size.height - 80);

    // Large smooth circular arc
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 40, // controls how round/deep the curve is
      size.width,
      size.height - 80,
    );

    // Close shape
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
