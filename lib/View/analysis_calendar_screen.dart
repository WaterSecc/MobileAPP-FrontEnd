import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/filled_button.dart';
import 'package:watersec_mobileapp_front/View/components/text_button.dart';
import 'package:watersec_mobileapp_front/ViewModel/devicesViewModel.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/View/components/filter_popup.dart';

class AnalysisCalendarPage extends StatefulWidget {
  final Function(List<Map<String, String>>, DateTime, DateTime)
      onFiltersAndDatesSelected;

  const AnalysisCalendarPage({
    super.key,
    required this.onFiltersAndDatesSelected,
  });

  @override
  State<AnalysisCalendarPage> createState() => _AnalysisCalendarPageState();
}

class _AnalysisCalendarPageState extends State<AnalysisCalendarPage> {
  // Filters (floors)
  List<Map<String, String>> selectedFloors = [];

  // Dates (always clamped to [minDate..today])
  late DateTime _selectedStartDate;
  late DateTime _selectedEndDate;

  // UI
  bool _showQuickButtons = true;

  // Formats
  final DateFormat _headerDateFormat = DateFormat('d MMM yyyy');
  final DateFormat _monthTitleFormat = DateFormat('MMMM');

  _CalendarMode _mode = _CalendarMode.today;

  // Period picking state (period uses same grid)
  bool _periodPickingEnd = false;

  // Controllers (reliable jump)
  final ScrollController _daysScroll = ScrollController();
  final ScrollController _monthsScroll = ScrollController();

  // Timeline months + offsets
  late List<DateTime> _months;
  late Map<String, double> _monthOffsets; // "yyyy-mm" -> offset

  // ✅ Ensures month title is visible (not clipped) when we jump to current month
  static const double _monthTitleRevealOffset = 90;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get _minDate {
    final t = _today;
    return DateTime(t.year - 4, t.month, t.day);
  }

  bool _isAfterToday(DateTime d) => d.isAfter(_today);

  DateTime _clamp(DateTime d) {
    if (d.isAfter(_today)) return _today;
    if (d.isBefore(_minDate)) return _minDate;
    return d;
  }

  // Timeline start/end:
  // UP until Jan (today.year-4)
  // DOWN until (today.year+1, today.month)
  DateTime get _timelineStartMonth {
    final t = _today;
    return DateTime(t.year - 4, 1, 1);
  }

  DateTime get _timelineEndMonth {
    final t = _today;
    return DateTime(t.year + 1, t.month, 1);
  }

  List<DateTime> _monthsTimeline() {
    final start = _timelineStartMonth;
    final end = _timelineEndMonth;
    final list = <DateTime>[];
    var cur = DateTime(start.year, start.month, 1);
    while (!cur.isAfter(end)) {
      list.add(cur);
      cur = DateTime(cur.year, cur.month + 1, 1);
    }
    return list;
  }

  String _keyForMonth(DateTime m) =>
      "${m.year}-${m.month.toString().padLeft(2, '0')}";

  // ---------- Heights / offsets ----------
  static const double _monthTitleTopPadding = 14;
  static const double _monthTitleBottomPadding = 10;
  static const double _monthTitleFont = 24;
  static const double _afterGridSpacing = 16;
  static const double _yearHeaderTopSpacing = 8;
  static const double _yearHeaderFont = 44;

  // Fixed day cell size (predictable height)
  static const double _cellExtent = 46;

  double get _titleBlockHeight =>
      _monthTitleTopPadding + _monthTitleBottomPadding + _monthTitleFont + 4;

  double get _yearHeaderBlockHeight =>
      _yearHeaderTopSpacing + _yearHeaderFont + 6;

  int _rowsForMonth(DateTime m) {
    final first = DateTime(m.year, m.month, 1);
    final last = DateTime(m.year, m.month + 1, 0);

    final leadingEmpty = (first.weekday - DateTime.monday) % 7;
    final totalCells = leadingEmpty + last.day;
    return (totalCells / 7.0).ceil();
  }

  double _estimatedMonthBlockHeight(DateTime m) {
    final rows = _rowsForMonth(m);
    final showYearHeader = (m.month == 1);
    return (showYearHeader ? _yearHeaderBlockHeight : 0) +
        _titleBlockHeight +
        (rows * _cellExtent) +
        _afterGridSpacing;
  }

  void _buildOffsets() {
    _months = _monthsTimeline();
    _monthOffsets = {};

    // ListView padding top in days view:
    const double listTopPadding = 4;
    double offset = listTopPadding;

    for (final m in _months) {
      _monthOffsets[_keyForMonth(m)] = offset;
      offset += _estimatedMonthBlockHeight(m);
    }
  }

  void _jumpToCurrentMonthDays() {
    final cur = DateTime(_today.year, _today.month, 1);
    final key = _keyForMonth(cur);
    final off = _monthOffsets[key] ?? 0.0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_daysScroll.hasClients) return;

      // ✅ reveal month title (so user sees "February 2026")
      final target = math.max(0.0, off - _monthTitleRevealOffset);
      _daysScroll.jumpTo(target);
    });
  }

  void _jumpToCurrentYearMonths() {
    final startYear = _today.year - 4;
    final endYear = _today.year + 1;
    final years = List.generate(endYear - startYear + 1, (i) => startYear + i);

    // Build offset: padding top = 10
    double offset = 10;
    for (final y in years) {
      if (y == _today.year) break;
      offset += _monthYearBlockHeight();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_monthsScroll.hasClients) return;

      // slight reveal so the year title isn’t clipped
      final target = math.max(0.0, offset - 40.0).toDouble();
      _monthsScroll.jumpTo(target);
    });
  }

  double _monthYearBlockHeight() {
    const double yearText = 54;
    const double afterYear = 16;
    const double gridRows = 3;
    const double pillHeight = 46;
    const double mainAxisSpacing = 16;
    const double bottom = 30;

    final gridHeight =
        (gridRows * pillHeight) + ((gridRows - 1) * mainAxisSpacing);

    return yearText + afterYear + gridHeight + bottom;
  }

  void _showCurrentOnModeChange(_CalendarMode newMode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (newMode == _CalendarMode.month) {
        _jumpToCurrentYearMonths();
      } else {
        _jumpToCurrentMonthDays();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _selectedStartDate = _today;
    _selectedEndDate = _today;
    _mode = _CalendarMode.today;

    _buildOffsets();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _jumpToCurrentMonthDays();
    });

    Future.microtask(() async {
      await Provider.of<DevicesViewModel>(context, listen: false)
          .fetchDevices(context);
    });
  }

  // ───────────────────────── Ranges ─────────────────────────

  void _setRangeToday() {
    final t = _today;
    setState(() {
      _mode = _CalendarMode.today;
      _periodPickingEnd = false;
      _selectedStartDate = t;
      _selectedEndDate = t;
    });
    _showCurrentOnModeChange(_CalendarMode.today);
  }

  void _setRangeDay(DateTime day) {
    final d = _clamp(DateTime(day.year, day.month, day.day));
    setState(() {
      _mode = _CalendarMode.day;
      _periodPickingEnd = false;
      _selectedStartDate = d;
      _selectedEndDate = d;
    });
    _showCurrentOnModeChange(_CalendarMode.day);
  }

  void _setRangeWeekStartAny(DateTime startDay) {
    final start = _clamp(DateTime(startDay.year, startDay.month, startDay.day));
    var end = start.add(const Duration(days: 6));

    if (end.isAfter(_today)) {
      end = _today;
      final shiftedStart = end.subtract(const Duration(days: 6));
      setState(() {
        _mode = _CalendarMode.week;
        _periodPickingEnd = false;
        _selectedStartDate = _clamp(shiftedStart);
        _selectedEndDate = end;
      });
      _showCurrentOnModeChange(_CalendarMode.week);
      return;
    }

    setState(() {
      _mode = _CalendarMode.week;
      _periodPickingEnd = false;
      _selectedStartDate = start;
      _selectedEndDate = _clamp(end);
    });
    _showCurrentOnModeChange(_CalendarMode.week);
  }

  void _setRangeMonth(DateTime monthDay) {
    final t = _today;
    final first = DateTime(monthDay.year, monthDay.month, 1);
    final last = DateTime(monthDay.year, monthDay.month + 1, 0);

    final clampedFirst = _clamp(first);
    final clampedLast = _clamp(last);

    final end = (monthDay.year == t.year && monthDay.month == t.month)
        ? t
        : clampedLast;

    setState(() {
      _mode = _CalendarMode.month;
      _periodPickingEnd = false;
      _selectedStartDate = clampedFirst;
      _selectedEndDate = end;
    });
    _showCurrentOnModeChange(_CalendarMode.month);
  }

  void _setModeMonth() {
    setState(() {
      _mode = _CalendarMode.month;
      _periodPickingEnd = false;
    });
    _showCurrentOnModeChange(_CalendarMode.month);
  }

  void _setModePeriod() {
    setState(() {
      _mode = _CalendarMode.period;
      _periodPickingEnd = false;
    });
    _showCurrentOnModeChange(_CalendarMode.period);
  }

  Future<void> _openFilterPopup() async {
    final result = await showDialog<List<Map<String, String>>>(
      context: context,
      barrierDismissible: true,
      builder: (_) => FiltersPopup(
        initialSelectedFloors: selectedFloors,
      ),
    );

    if (result != null) {
      setState(() => selectedFloors = result);
    }
  }

  void _applyAndClose() {
    widget.onFiltersAndDatesSelected(
      selectedFloors,
      _selectedStartDate,
      _selectedEndDate,
    );
    Navigator.pop(context);
  }

  String _rangeLabel() {
    final s = DateFormat('dd/MM/yyyy').format(_selectedStartDate);
    final e = DateFormat('dd/MM/yyyy').format(_selectedEndDate);
    if (s == e) return s;
    return "$s  -  $e";
  }

  void _onDayTap(DateTime day) {
    if (_isAfterToday(day)) return;
    if (day.isBefore(_minDate)) return;

    if (_mode == _CalendarMode.week) {
      _setRangeWeekStartAny(day);
      return;
    }

    if (_mode == _CalendarMode.period) {
      final d = _clamp(DateTime(day.year, day.month, day.day));

      if (!_periodPickingEnd) {
        setState(() {
          _selectedStartDate = d;
          _selectedEndDate = d;
          _periodPickingEnd = true;
        });
      } else {
        DateTime s = _selectedStartDate;
        DateTime e = d;

        if (e.isBefore(s)) {
          final tmp = s;
          s = e;
          e = tmp;
        }

        setState(() {
          _selectedStartDate = _clamp(s);
          _selectedEndDate = _clamp(e);
          _periodPickingEnd = false;
        });
      }
      return;
    }

    _setRangeDay(day);
  }

  // ───────────────────────── UI ─────────────────────────

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.background;
    final fg = Theme.of(context).colorScheme.secondary;
    final t = _today;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: fg),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() => _showQuickButtons = !_showQuickButtons);
                    },
                    icon: Icon(Icons.calendar_today_outlined, color: fg),
                  ),
                  IconButton(
                    onPressed: _openFilterPopup,
                    icon: Icon(FontAwesomeIcons.sliders, size: 18, color: fg),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Calendar",
                  style: TextStyle(
                    color: fg,
                    fontSize: 44,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            if (_showQuickButtons)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _QuickButton(
                      label: "Today",
                      icon: Icons.check_box_outlined,
                      selected: _mode == _CalendarMode.today,
                      onTap: _setRangeToday,
                      fg: fg,
                    ),
                    _QuickButton(
                      label: "Day",
                      icon: Icons.remove,
                      selected: _mode == _CalendarMode.day,
                      onTap: () => _setRangeDay(_selectedEndDate),
                      fg: fg,
                    ),
                    _QuickButton(
                      label: "Week",
                      icon: Icons.view_week_outlined,
                      selected: _mode == _CalendarMode.week,
                      onTap: () => _setRangeWeekStartAny(_selectedEndDate),
                      fg: fg,
                    ),
                    _QuickButton(
                      label: "Month",
                      icon: Icons.calendar_view_month_outlined,
                      selected: _mode == _CalendarMode.month,
                      onTap: _setModeMonth,
                      fg: fg,
                    ),
                    _QuickButton(
                      label: "Period",
                      icon: Icons.date_range_outlined,
                      selected: _mode == _CalendarMode.period,
                      onTap: _setModePeriod,
                      fg: fg,
                    ),
                  ],
                ),
              ),
            if (_mode != _CalendarMode.month)
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 2, 18, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Dow("MON", fg: fg),
                    _Dow("TUE", fg: fg),
                    _Dow("WED", fg: fg),
                    _Dow("THU", fg: fg),
                    _Dow("FRI", fg: fg),
                    _Dow("SAT", fg: fg),
                    _Dow("SUN", fg: fg),
                  ],
                ),
              ),
            Expanded(
              child: _mode == _CalendarMode.month
                  ? _MonthSectionLikeScreenshot(
                      controller: _monthsScroll,
                      fg: fg,
                      bg: bg,
                      today: t,
                      startYear: t.year - 4,
                      endYear: t.year + 1,
                      highlightedYear: _selectedStartDate.year,
                      highlightedMonth: _selectedStartDate.month,
                      onMonthTap: (year, month) {
                        final maxAllowed = DateTime(t.year + 1, t.month, 1);
                        final tapped = DateTime(year, month, 1);
                        if (tapped.isAfter(maxAllowed)) return;
                        if (year == t.year && month > t.month) return;

                        _setRangeMonth(DateTime(year, month, 1));
                      },
                    )
                  : _DaysTimeline(
                      controller: _daysScroll,
                      months: _months,
                      fg: fg,
                      today: t,
                      minDate: _minDate,
                      monthTitleFormat: _monthTitleFormat,
                      selectedStart: _selectedStartDate,
                      selectedEnd: _selectedEndDate,
                      onDayTap: _onDayTap,
                      cellExtent: _cellExtent,
                      highlightRangeFill: (_mode == _CalendarMode.period),
                    ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
              color: bg,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: MyFilledButton(
                            onPressed: _applyAndClose,
                            text: AppLocale.Apply.getString(context),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: MyTextBtn(
                            text: AppLocale.Cancel.getString(context),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _CalendarMode { today, day, week, month, period }

// ───────────────────────── Widgets ─────────────────────────

class _QuickButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color fg;

  const _QuickButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    final c = selected ? fg : fg.withOpacity(0.35);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Column(
          children: [
            Icon(icon, color: c, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: c,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dow extends StatelessWidget {
  final String t;
  final Color fg;
  const _Dow(this.t, {required this.fg});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Center(
        child: Text(
          t,
          style: TextStyle(
            color: fg.withOpacity(0.55),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

/// DAYS timeline: Jan (year-4) .. (year+1,currentMonth)
class _DaysTimeline extends StatelessWidget {
  final ScrollController controller;
  final List<DateTime> months;
  final Color fg;
  final DateTime today;
  final DateTime minDate;
  final DateFormat monthTitleFormat;

  final DateTime selectedStart;
  final DateTime selectedEnd;
  final ValueChanged<DateTime> onDayTap;

  final double cellExtent;

  /// When true (Period mode), fill the in-between days with newBlue too.
  final bool highlightRangeFill;

  const _DaysTimeline({
    required this.controller,
    required this.months,
    required this.fg,
    required this.today,
    required this.minDate,
    required this.monthTitleFormat,
    required this.selectedStart,
    required this.selectedEnd,
    required this.onDayTap,
    required this.cellExtent,
    required this.highlightRangeFill,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final mStart in months) {
      final year = mStart.year;
      final month = mStart.month;

      final monthEnd = DateTime(year, month + 1, 0);
      if (monthEnd.isBefore(minDate)) continue;

      final showYearHeader = (month == 1);
      final title = "${monthTitleFormat.format(mStart)} $year";

      children.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showYearHeader) ...[
              const SizedBox(height: 8),
              Text(
                "$year",
                style: TextStyle(
                  color: fg.withOpacity(0.18),
                  fontSize: 44,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 10),
              child: Text(
                title,
                style: TextStyle(
                  color: newBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _MonthGridDaysFixed(
              year: year,
              month: month,
              fg: fg,
              today: today,
              minDate: minDate,
              selectedStart: selectedStart,
              selectedEnd: selectedEnd,
              onDayTap: onDayTap,
              cellExtent: cellExtent,
              highlightRangeFill: highlightRangeFill,
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
      children: children,
    );
  }
}

/// MONTH section like screenshot: year header + 12 pills grid
class _MonthSectionLikeScreenshot extends StatelessWidget {
  final ScrollController controller;
  final Color fg;
  final Color bg;
  final DateTime today;

  final int startYear;
  final int endYear;

  final int highlightedYear;
  final int highlightedMonth;

  final void Function(int year, int month) onMonthTap;

  const _MonthSectionLikeScreenshot({
    required this.controller,
    required this.fg,
    required this.bg,
    required this.today,
    required this.startYear,
    required this.endYear,
    required this.highlightedYear,
    required this.highlightedMonth,
    required this.onMonthTap,
  });

  static const _labels = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  @override
  Widget build(BuildContext context) {
    final years = List.generate(endYear - startYear + 1, (i) => startYear + i);

    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
      itemCount: years.length,
      itemBuilder: (context, yi) {
        final year = years[yi];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$year",
              style: TextStyle(
                color: fg.withOpacity(0.35),
                fontSize: 54,
                fontWeight: FontWeight.w300,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.8,
              ),
              itemBuilder: (context, i) {
                final month = i + 1;

                final isHighlighted =
                    (year == highlightedYear && month == highlightedMonth);

                final maxAllowed = DateTime(today.year + 1, today.month, 1);
                final tapped = DateTime(year, month, 1);
                final isDisabled = tapped.isAfter(maxAllowed) ||
                    (year == today.year && month > today.month);

                final Color textColor = isDisabled
                    ? fg.withOpacity(0.18)
                    : (isHighlighted ? Colors.white : fg.withOpacity(0.55));

                final Color bgColor =
                    isHighlighted ? newBlue : Colors.transparent;

                final Color borderColor = isHighlighted
                    ? Colors.transparent
                    : (isDisabled
                        ? fg.withOpacity(0.12)
                        : fg.withOpacity(0.35));

                return GestureDetector(
                  onTap: isDisabled ? null : () => onMonthTap(year, month),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: borderColor, width: 1),
                    ),
                    child: Text(
                      _labels[i],
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight:
                            isHighlighted ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        );
      },
    );
  }
}

/// Fixed-height month grid (predictable scroll) 
class _MonthGridDaysFixed extends StatelessWidget {
  final int year;
  final int month;

  final Color fg;
  final DateTime today;
  final DateTime minDate;

  final DateTime selectedStart;
  final DateTime selectedEnd;

  final ValueChanged<DateTime> onDayTap;

  final double cellExtent;

  /// If true: in-between dates also get newBlue background (lighter than selected)
  final bool highlightRangeFill;

  const _MonthGridDaysFixed({
    required this.year,
    required this.month,
    required this.fg,
    required this.today,
    required this.minDate,
    required this.selectedStart,
    required this.selectedEnd,
    required this.onDayTap,
    required this.cellExtent,
    required this.highlightRangeFill,
  });

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _inRange(DateTime d, DateTime s, DateTime e) {
    final dd = DateTime(d.year, d.month, d.day);
    final ss = DateTime(s.year, s.month, s.day);
    final ee = DateTime(e.year, e.month, e.day);
    return (dd.isAtSameMomentAs(ss) || dd.isAfter(ss)) &&
        (dd.isAtSameMomentAs(ee) || dd.isBefore(ee));
  }

  @override
  Widget build(BuildContext context) {
    final first = DateTime(year, month, 1);
    final last = DateTime(year, month + 1, 0);

    final leadingEmpty = (first.weekday - DateTime.monday) % 7;
    final totalDays = last.day;

    final totalCells = leadingEmpty + totalDays;
    final rows = (totalCells / 7.0).ceil();
    final gridHeight = rows * cellExtent;

    final cells = <Widget>[];

    for (int i = 0; i < leadingEmpty; i++) {
      cells.add(const SizedBox.shrink());
    }

    for (int d = 1; d <= totalDays; d++) {
      final day = DateTime(year, month, d);

      final bool isDisabled = day.isAfter(today) || day.isBefore(minDate);

      final isSelectedStart = _isSameDay(day, selectedStart);
      final isSelectedEnd = _isSameDay(day, selectedEnd);
      final isSelected = isSelectedStart || isSelectedEnd;

      final isInRange = _inRange(day, selectedStart, selectedEnd);

      // Fill in-between range in Period mode
      final bool fillRange = highlightRangeFill && isInRange && !isSelected;

      final Color bgColor = isSelected
          ? newBlue
          : (fillRange ? newBlue.withOpacity(0.22) : Colors.transparent);

      final Color textColor = isDisabled
          ? fg.withOpacity(0.18)
          : (isSelected
              ? Colors.white
              : fg.withOpacity(isInRange ? 0.90 : 0.45));

      cells.add(
        GestureDetector(
          onTap: isDisabled ? null : () => onDayTap(day),
          child: Center(
            child: Container(
              width: cellExtent,
              height: cellExtent,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
              ),
              child: Center(
                child: Text(
                  "$d",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Fill to complete last row (so height matches)
    while (cells.length % 7 != 0) {
      cells.add(const SizedBox.shrink());
    }

    return SizedBox(
      height: gridHeight,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cells.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisExtent: cellExtent,
        ),
        itemBuilder: (context, i) => cells[i],
      ),
    );
  }
}
