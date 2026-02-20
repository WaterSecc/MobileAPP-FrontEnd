import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';

import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/bottom_drawer.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
import 'package:watersec_mobileapp_front/View/components/sensor_screen.dart';
import 'package:watersec_mobileapp_front/ViewModel/categoriesViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/settingsGETViewModel.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';
import 'package:watersec_mobileapp_front/View/threshold_screen.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _searchController = TextEditingController();

  String? _selectedMainCategory;
  String? _selectedSubCategory;
  bool _showDropdown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SettingsViewModel>(context, listen: false).fetchSettings();
      Provider.of<CategoryViewModel>(context, listen: false).fetchCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // UI helpers (design only)
  // ─────────────────────────────────────────────
  Widget _topThresholdCard(SettingsViewModel vm) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocale.GlobalConsumptionThreshold.getString(context),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${vm.globalConsumptionThreshold} Litres",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 36,
            width: 92,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: newBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () {
                _showGlobalThresholdBottomSheet(
                  context,
                  vm.globalConsumptionThreshold,
                );
              },
              child: const Text(
                "Edit",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    final label = _selectedSubCategory != null
        ? "${AppLocale.Searchby.getString(context)} $_selectedMainCategory: $_selectedSubCategory"
        : AppLocale.Search.getString(context);

    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: TextField(
        controller: _searchController,
        readOnly: true,
        onTap: () {
          setState(() => _showDropdown = !_showDropdown);
        },
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedMainCategory = null;
                _selectedSubCategory = null;
                _showDropdown = false;
              });
            },
            icon: const Icon(Icons.close),
          ),
          border: InputBorder.none,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black87, width: 1),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black87, width: 1.2),
          ),
        ),
      ),
    );
  }

  // Grouped header like: House 1 sensors (6)
  Widget _groupHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 14, 6, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              "sensors ($count)",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.65),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sensorCard({
    required dynamic sensor,
    required String mainCategory,
    required String subCategory,
    required SettingsViewModel settingsVM,
  }) {
    // In mock: subtitle is something like "Cold and Hot water"
    // We'll use: "$mainCategory and $subCategory" but if empty fallback.
    final subtitle = (mainCategory.isNotEmpty && subCategory.isNotEmpty)
        ? "$mainCategory and $subCategory"
        : (mainCategory.isNotEmpty ? mainCategory : subCategory);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: newBlue, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SensorDetailsScreen(
                sensor: sensor,
                settingsViewModel: settingsVM,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + chevron
              Row(
                children: [
                  Expanded(
                    child: Text(
                      sensor.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: newBlue, size: 26),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.65),
                ),
              ),
              const SizedBox(height: 10),
              Container(height: 1, color: const Color(0xFFB7D6FF)),
              const SizedBox(height: 10),

              // Two rows like the mock:
              Row(
                children: [
                  Text(
                    "${AppLocale.Threshold.getString(context)}:",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${sensor.threshold} L",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text(
                    "Avg use:",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Your model has "consumption", mock says "Avg use"
                  Text(
                    "${sensor.consumption} L",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Existing dropdown (keep your logic)
  // ─────────────────────────────────────────────
  Widget _buildCategoryDropdown(CategoryViewModel categoryViewModel) {
    final uniqueMainCategories = categoryViewModel.getUniqueMainCategories();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.40,
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Material(
          elevation: 2,
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(12),
          child: SingleChildScrollView(
            child: Column(
              children: uniqueMainCategories.map((mainCategory) {
                return ExpansionTile(
                  title: Text(
                    mainCategory,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  children: categoryViewModel
                      .getSubCategoryNames(
                        categoryViewModel.getMainCategoryIdByName(mainCategory),
                      )
                      .map(
                        (subCategoryName) => ListTile(
                          title: Text(
                            subCategoryName,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedMainCategory = mainCategory;
                              _selectedSubCategory = subCategoryName;
                              _searchController.text =
                                  '$mainCategory : $subCategoryName';
                              _showDropdown = false;
                            });
                          },
                        ),
                      )
                      .toList(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Keep your existing logic: show ThresholdScreen
  // ─────────────────────────────────────────────
  void _showGlobalThresholdBottomSheet(
      BuildContext context, int currentThreshold) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ThresholdScreen(currentThreshold: currentThreshold);
      },
    );
  }

  // ─────────────────────────────────────────────
  // Keep your existing edit popup logic
  // (unchanged except formatting)
  // ─────────────────────────────────────────────
  void _showEditPopup(BuildContext context, sensor, String mainCategory,
      String subCategory, SettingsViewModel settingsViewModel) {
    final TextEditingController _nameController =
        TextEditingController(text: sensor.name);
    final TextEditingController _thresholdController =
        TextEditingController(text: sensor.threshold.toString());
    final TextEditingController _consumptionController =
        TextEditingController(text: sensor.consumption.toString());
    final TextEditingController _durationController =
        TextEditingController(text: sensor.duration.toString());

    final categoryViewModel =
        Provider.of<CategoryViewModel>(context, listen: false);
    final uniqueMainCategories = categoryViewModel.categories
        .map((cat) => cat.mainCategoryName)
        .toSet()
        .toList();

    String? selectedMainCategory = mainCategory;
    String? selectedSubCategory = subCategory;

    List<String> subCategoriesForSelectedMain = categoryViewModel.categories
        .where((cat) => cat.mainCategoryName == selectedMainCategory)
        .map((cat) => cat.subCategoryName)
        .toSet()
        .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text(
                AppLocale.EditSensor.getString(context),
                style: TextStyles.Header4Style(
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: AppLocale.Sensor.getString(context),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: selectedMainCategory,
                      onChanged: (newValue) {
                        setState(() {
                          selectedMainCategory = newValue;
                          subCategoriesForSelectedMain = categoryViewModel
                              .categories
                              .where((cat) =>
                                  cat.mainCategoryName == selectedMainCategory)
                              .map((cat) => cat.subCategoryName)
                              .toSet()
                              .toList();
                          selectedSubCategory = null;
                        });
                      },
                      items: uniqueMainCategories
                          .map(
                            (mainCategory) => DropdownMenuItem<String>(
                              value: mainCategory,
                              child: Text(mainCategory),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: selectedSubCategory,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSubCategory = newValue;
                        });
                      },
                      items: subCategoriesForSelectedMain
                          .map(
                            (subCategory) => DropdownMenuItem<String>(
                              value: subCategory,
                              child: Text(subCategory),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _thresholdController,
                      decoration: InputDecoration(
                        labelText: AppLocale.Threshold.getString(context),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _consumptionController,
                      decoration: InputDecoration(
                        labelText: AppLocale.Consommation.getString(context),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _durationController,
                      decoration: InputDecoration(
                        labelText: AppLocale.Duration.getString(context),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocale.Cancel.getString(context),
                    style: TextStyles.txtBtnNOStyle(blue),
                  ),
                ),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                      Theme.of(context).colorScheme.tertiaryFixed,
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final updatedSensor = sensor.copyWith(
                        name: _nameController.text,
                        threshold: int.parse(_thresholdController.text),
                        consumption: int.parse(_consumptionController.text),
                        duration: int.parse(_durationController.text),
                        mainCategoryId:
                            categoryViewModel.getMainCategoryIdByName(
                                    selectedMainCategory!) ??
                                sensor.mainCategoryId,
                        subCategoryId: categoryViewModel
                                .getSubCategoryIdByName(selectedSubCategory!) ??
                            sensor.subCategoryId,
                      );

                      settingsViewModel.updateSensor(updatedSensor);
                      await settingsViewModel.updateSensorData();

                      if (context.mounted) Navigator.of(context).pop();

                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocale.ChangedSuccessfully.getString(context),
                            style: TextStyle(color: black),
                          ),
                          backgroundColor: green,
                        ),
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${AppLocale.Error.getString(context)} $error",
                            style: TextStyle(color: white),
                          ),
                          backgroundColor: red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    AppLocale.Save.getString(context),
                    style: TextStyles.txtBtnNOStyle(white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  // Main build: keep logic, change design
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final settingsVM = Provider.of<SettingsViewModel>(context);
    final categoryVM = Provider.of<CategoryViewModel>(context);

    final sensors = settingsVM.sensorsConsumptionsThresholds;

    final filteredSensors = sensors.where((sensor) {
      final sensorMainCategory =
          categoryVM.getMainCategoryName(sensor.mainCategoryId);
      final sensorSubCategory =
          categoryVM.getSubCategoryName(sensor.subCategoryId);

      return (_selectedMainCategory == null && _selectedSubCategory == null) ||
          (sensorMainCategory == _selectedMainCategory &&
              sensorSubCategory == _selectedSubCategory);
    }).toList();

    // Group sensors by mainCategory name (e.g., "House 1")
    final Map<String, List<dynamic>> grouped = {};
    for (final s in filteredSensors) {
      final groupName =
          categoryVM.getMainCategoryName(s.mainCategoryId).trim().isEmpty
              ? "House"
              : categoryVM.getMainCategoryName(s.mainCategoryId);
      grouped.putIfAbsent(groupName, () => []);
      grouped[groupName]!.add(s);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(
          title: AppLocale.Settings.getString(context),
        ),
      ),
      endDrawer: ProfileEndDrawer(
        onProfileTap: () => Navigator.pushReplacementNamed(context, '/profile'),
        onLogout: () => Navigator.pushReplacementNamed(context, '/login'),
      ),
      bottomNavigationBar: const MyBottomNav(currentIndex: 4),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() => _showDropdown = false);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          children: [
            _topThresholdCard(settingsVM),
            _searchBar(),
            if (_showDropdown) _buildCategoryDropdown(categoryVM),
            const SizedBox(height: 10),

            // Cards list grouped like the mock
            ...grouped.entries.map((entry) {
              final groupName = entry.key;
              final list = entry.value;

              return Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _groupHeader(groupName, list.length),
                    ...List.generate(list.length, (i) {
                      final sensor = list[i];
                      final mainCategory =
                          categoryVM.getMainCategoryName(sensor.mainCategoryId);
                      final subCategory =
                          categoryVM.getSubCategoryName(sensor.subCategoryId);

                      return _sensorCard(
                        sensor: sensor,
                        mainCategory: mainCategory,
                        subCategory: subCategory,
                        settingsVM: settingsVM,
                      );
                    }),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
