import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';

import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/filled_button.dart';
import 'package:watersec_mobileapp_front/View/components/text_field.dart';
import 'package:watersec_mobileapp_front/ViewModel/categoriesViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/settingsGETViewModel.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

/// Screen that replaces the old Edit Sensor popup
/// and matches the provided UI mock.
///
/// Usage:
/// Navigator.push(context, MaterialPageRoute(
///   builder: (_) => SensorDetailsScreen(
///     sensor: sensor,
///     settingsViewModel: settingsViewModel,
///   ),
/// ));
class SensorDetailsScreen extends StatefulWidget {
  final dynamic sensor; // keep dynamic to match your current popup signature
  final SettingsViewModel settingsViewModel;

  const SensorDetailsScreen({
    Key? key,
    required this.sensor,
    required this.settingsViewModel,
  }) : super(key: key);

  @override
  State<SensorDetailsScreen> createState() => _SensorDetailsScreenState();
}

class _SensorDetailsScreenState extends State<SensorDetailsScreen> {
  bool _saving = false;

  String _mainCategoryName(CategoryViewModel catVM) =>
      catVM.getMainCategoryName(widget.sensor.mainCategoryId);

  String _subCategoryName(CategoryViewModel catVM) =>
      catVM.getSubCategoryName(widget.sensor.subCategoryId);

  // ----- UI helpers -----
  Widget _divider() => Container(height: 1, color: const Color(0xFFB7D6FF));

  Widget _row({
    required String left,
    required String right,
    bool showDivider = true,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  left,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                right,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (showDivider) _divider(),
        ],
      ),
    );
  }

  Future<void> _applyUpdate(dynamic updatedSensor) async {
    if (_saving) return;

    setState(() => _saving = true);
    try {
      widget.settingsViewModel.updateSensor(updatedSensor);
      await widget.settingsViewModel.updateSensorData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocale.ChangedSuccessfully.getString(context),
            style: TextStyle(color: black),
          ),
          backgroundColor: green,
        ),
      );

      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${AppLocale.Error.getString(context)} $e",
            style: TextStyle(color: white),
          ),
          backgroundColor: red,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ----- Edit Threshold Sheet -----
  Future<void> _editThresholdSheet() async {
    final controller =
        TextEditingController(text: widget.sensor.threshold.toString());

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _EditSheetShell(
          title: "Alerts",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocale.Threshold.getString(context),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              MyTextField(
                hint: "${AppLocale.Threshold.getString(context)} (L)",
                controller: controller,
                onChanged: (String) {},
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: MyFilledButton(
                  text: _saving ? "..." : AppLocale.Save.getString(context),
                  onPressed: _saving
                      ? null
                      : () async {
                          final newThreshold =
                              int.tryParse(controller.text.trim());
                          if (newThreshold == null || newThreshold < 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Invalid threshold value."),
                                backgroundColor: red,
                              ),
                            );
                            return;
                          }

                          final updated = widget.sensor.copyWith(
                            threshold: newThreshold,
                          );

                          if (context.mounted) Navigator.pop(context);
                          await _applyUpdate(updated);
                        },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    controller.dispose();
  }

  // ----- Edit Sensor Info Sheet (name + category) -----
  Future<void> _editSensorInfoSheet(CategoryViewModel catVM) async {
    final nameController = TextEditingController(text: widget.sensor.name);

    final uniqueMainCategories =
        catVM.categories.map((c) => c.mainCategoryName).toSet().toList();

    String? selectedMain = _mainCategoryName(catVM);
    String? selectedSub = _subCategoryName(catVM);

    List<String> subCatsForSelectedMain = catVM.categories
        .where((c) => c.mainCategoryName == selectedMain)
        .map((c) => c.subCategoryName)
        .toSet()
        .toList();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return _EditSheetShell(
              title: "Sensor Info",
              child: Column(
                children: [
                  MyTextField(
                    hint: AppLocale.Sensor.getString(context),
                    controller: nameController,
                    onChanged: (v) {},
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedMain,
                    decoration: InputDecoration(
                      labelText: AppLocale.Category.getString(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: uniqueMainCategories
                        .map(
                          (m) => DropdownMenuItem(
                            value: m,
                            child: Text(m),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      setSheetState(() {
                        selectedMain = v;
                        subCatsForSelectedMain = catVM.categories
                            .where((c) => c.mainCategoryName == selectedMain)
                            .map((c) => c.subCategoryName)
                            .toSet()
                            .toList();
                        selectedSub = null;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedSub,
                    decoration: InputDecoration(
                      labelText: "Tag",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: subCatsForSelectedMain
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(s),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setSheetState(() => selectedSub = v),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: MyFilledButton(
                      text: _saving ? "..." : AppLocale.Save.getString(context),
                      onPressed: _saving
                          ? null
                          : () async {
                              if (selectedMain == null || selectedSub == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        "Please select category & tag."),
                                    backgroundColor: red,
                                  ),
                                );
                                return;
                              }

                              final updated = widget.sensor.copyWith(
                                name: nameController.text.trim(),
                                mainCategoryId: catVM.getMainCategoryIdByName(
                                        selectedMain!) ??
                                    widget.sensor.mainCategoryId,
                                subCategoryId: catVM
                                        .getSubCategoryIdByName(selectedSub!) ??
                                    widget.sensor.subCategoryId,
                              );

                              if (context.mounted) Navigator.pop(context);
                              await _applyUpdate(updated);
                            },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );

    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catVM = context.watch<CategoryViewModel>();

    final sensorName = (widget.sensor.name ?? '').toString();
    final buildingName =
        _mainCategoryName(catVM); // using main category as “House 1”
    final thresholdText = widget.sensor.threshold?.toString() ?? '--';

    final avgDuration = "${widget.sensor.duration ?? 0} min";
    final avgUse = "${widget.sensor.consumption ?? 0} L";

    final categoryText =
        "${_mainCategoryName(catVM)} : ${_subCategoryName(catVM)}";
    final tagText = _subCategoryName(catVM);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          sensorName,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // “House 1” subtitle like mock
            Padding(
              padding: const EdgeInsets.only(left: 56),
              child: Text(
                buildingName,
                style: TextStyle(
                  color: newBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // ===== Alerts card =====
            _CardShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Alerts",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocale.Threshold.getString(context),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 110,
                        height: 36,
                        child: MyFilledButton(
                          text: "Edit",
                          onPressed: _editThresholdSheet,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ===== Usage card =====
            _CardShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Usage",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _row(left: "Avg duration per use", right: avgDuration),
                  _row(
                    left: "Avg consumption per use",
                    right: avgUse,
                    showDivider: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ===== Sensor Info card =====
            _CardShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sensor Info",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _row(left: "Name", right: sensorName),
                  _row(left: "Category", right: categoryText),
                  _row(left: "Tag", right: tagText),
                  _row(
                    left: "Water Meter",
                    right: buildingName,
                    showDivider: false,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 110,
                      height: 36,
                      child: MyFilledButton(
                        text: _saving ? "..." : "Edit",
                        onPressed:
                            _saving ? null : () => _editSensorInfoSheet(catVM),
                      ),
                    ),
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

class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
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
      child: child,
    );
  }
}

class _EditSheetShell extends StatelessWidget {
  final String title;
  final Widget child;

  const _EditSheetShell({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        ),
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 14),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
