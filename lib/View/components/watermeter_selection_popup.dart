import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/filled_button.dart';
import 'package:watersec_mobileapp_front/View/components/textBtnNotOutlined.dart';
import 'package:watersec_mobileapp_front/View/components/text_button.dart';
import 'package:watersec_mobileapp_front/ViewModel/watermeterViewModel.dart';
import 'package:watersec_mobileapp_front/colors.dart';

class WaterMeterSelectionPopup extends StatefulWidget {
  final Function(List<String> selectedMeterIds) onMetersSelected;

  const WaterMeterSelectionPopup({super.key, required this.onMetersSelected});

  @override
  State<WaterMeterSelectionPopup> createState() =>
      _WaterMeterSelectionPopupState();
}

class _WaterMeterSelectionPopupState extends State<WaterMeterSelectionPopup> {
  late List<bool> _selectedMeters;
  late List<String> _selectedMeterIds;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<WaterMetersViewModel>(context, listen: false);

    _selectedMeters = List.generate(
      viewModel.watermeters.length,
      (index) => viewModel.selectedMeterIds
          .contains(viewModel.watermeters[index].identifier),
    );

    _selectedMeterIds = List.from(viewModel.selectedMeterIds);
  }

  void _clearAll(WaterMetersViewModel viewModel) {
    setState(() {
      _selectedMeters =
          List.generate(viewModel.watermeters.length, (index) => false);
      _selectedMeterIds.clear();
    });
  }

  void _selectAll(WaterMetersViewModel viewModel) {
    setState(() {
      _selectedMeters =
          List.generate(viewModel.watermeters.length, (index) => true);
      _selectedMeterIds =
          viewModel.watermeters.map((m) => m.identifier).toList();
    });
  }

  void _toggleMeter(int index, WaterMetersViewModel viewModel) {
    final meter = viewModel.watermeters[index];

    setState(() {
      _selectedMeters[index] = !_selectedMeters[index];
      if (_selectedMeters[index]) {
        if (!_selectedMeterIds.contains(meter.identifier)) {
          _selectedMeterIds.add(meter.identifier);
        }
      } else {
        _selectedMeterIds.remove(meter.identifier);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterMetersViewModel>(
      builder: (context, viewModel, child) {
        final w = MediaQuery.of(context).size.width;
        final h = MediaQuery.of(context).size.height;

        return Dialog(
          backgroundColor: Colors.white,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: SizedBox(
            width: w * 0.92,
            height: h * 0.72,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Title (top-left) =====
                  Text(
                    AppLocale.selectWaterMeters.getString(context),
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.85),
                      // fontFamily: Roboto,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ===== Select All / Clear All row =====
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _TopActionLink(
                          text: AppLocale.selectall.getString(context),
                          onTap: viewModel.watermeters.isEmpty
                              ? null
                              : () => _selectAll(viewModel),
                        ),
                        const SizedBox(width: 18),
                        _TopActionLink(
                          text: AppLocale.clearall.getString(context),
                          onTap: viewModel.watermeters.isEmpty
                              ? null
                              : () => _clearAll(viewModel),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ===== List =====
                  Expanded(
                    child: viewModel.watermeters.isEmpty
                        ? Center(
                            child: Text(
                              AppLocale.noWaterMeters.getString(context),
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.65),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: viewModel.watermeters.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final meter = viewModel.watermeters[index];

                              return InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => _toggleMeter(index, viewModel),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          meter.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      _SquareCheck(
                                        checked: _selectedMeters[index],
                                        onTap: () =>
                                            _toggleMeter(index, viewModel),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 14),

                  // ===== Bottom buttons =====
                  Row(
                    children: [
                      Expanded(
                        child: MyFilledButton(
                          text: "Save Changes",
                          onPressed: () {
                            widget.onMetersSelected(_selectedMeterIds);
                            viewModel.updateSelectedMeters(_selectedMeterIds);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: MyTextBtn(
                          text: "Cancel",
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ================= UI bits (match screenshot) =================

class _TopActionLink extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const _TopActionLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: enabled ? newBlue : newBlue.withValues(alpha: 0.35),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SquareCheck extends StatelessWidget {
  final bool checked;
  final VoidCallback onTap;

  const _SquareCheck({required this.checked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // square checkbox like the mock
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(3),
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: checked ? newBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: newBlue,
            width: 1,
          ),
        ),
        child: checked
            ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
            : null,
      ),
    );
  }
}

