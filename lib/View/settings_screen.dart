import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
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
  TextEditingController _searchController = TextEditingController();
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
  Widget build(BuildContext context) {
    final settingsViewModel = Provider.of<SettingsViewModel>(context);
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    final sensors = settingsViewModel.sensorsConsumptionsThresholds;

    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final uniqueMainCategories = categoryViewModel.getUniqueMainCategories();
    List<String> subCategoriesForSelectedMain = [];

    if (_selectedMainCategory != null) {
      subCategoriesForSelectedMain = categoryViewModel.getSubCategoryNames(
        categoryViewModel.getMainCategoryIdByName(_selectedMainCategory!),
      );
    }

    final filteredSensors = sensors.where((sensor) {
      final sensorMainCategory =
          categoryViewModel.getMainCategoryName(sensor.mainCategoryId);
      final sensorSubCategory =
          categoryViewModel.getSubCategoryName(sensor.subCategoryId);

      return (_selectedMainCategory == null && _selectedSubCategory == null) ||
          (sensorMainCategory == _selectedMainCategory &&
              sensorSubCategory == _selectedSubCategory);
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: MyDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(page: AppLocale.Settings.getString(context)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            _showDropdown = false; // Hide the dropdown when tapping outside
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              TextField(
                controller: _searchController,
                readOnly: true,
                onTap: () {
                  setState(() {
                    _showDropdown = !_showDropdown;
                  });
                },
                decoration: InputDecoration(
                  labelText: _selectedSubCategory != null
                      ? AppLocale.Searchby.getString(context) +
                          ' $_selectedMainCategory: $_selectedSubCategory'
                      : AppLocale.Search.getString(context),
                  prefixIcon: Icon(Icons.search, size: screenWidth * 0.06),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchController.clear();
                        _selectedMainCategory = null;
                        _selectedSubCategory = null;
                        _showDropdown = false;
                      });
                    },
                    child: Icon(Icons.clear, size: screenWidth * 0.06),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Visibility(
                visible: _showDropdown,
                child: _buildCategoryDropdown(categoryViewModel, screenWidth),
              ),
              SizedBox(height: screenHeight * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocale.GlobalConsumptionThreshold.getString(
                                context) +
                            ': ${settingsViewModel.globalConsumptionThreshold}',
                        style: TextStyles.header5Style(
                          Theme.of(context).colorScheme.secondary,
                        ),
                        overflow: TextOverflow
                            .ellipsis, // Ensures text doesn't overflow
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: blue,
                        size: 22,
                      ),
                      onPressed: () {
                        _showGlobalThresholdBottomSheet(context,
                            settingsViewModel.globalConsumptionThreshold);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredSensors.length,
                  itemBuilder: (context, index) {
                    final sensor = filteredSensors[index];
                    final mainCategory = categoryViewModel
                        .getMainCategoryName(sensor.mainCategoryId);
                    final subCategory = categoryViewModel
                        .getSubCategoryName(sensor.subCategoryId);

                    return Card(
                      color: Theme.of(context).colorScheme.background,
                      margin: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                      ),
                      child: InkWell(
                        onTap: () {
                          _showEditPopup(
                            context,
                            sensor,
                            mainCategory,
                            subCategory,
                            settingsViewModel,
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sensor.name,
                                style: TextStyle(
                                  fontSize: textScaleFactor * 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                AppLocale.Category.getString(context) +
                                    ': $mainCategory : $subCategory',
                                style: TextStyle(
                                  fontSize: textScaleFactor * 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                AppLocale.Threshold.getString(context) +
                                    ': ${sensor.threshold}',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              Text(
                                AppLocale.Consommation.getString(context) +
                                    ': ${sensor.consumption}',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              Text(
                                AppLocale.Duration.getString(context) +
                                    ': ${sensor.duration} mins',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(
      CategoryViewModel categoryViewModel, double screenWidth) {
    final uniqueMainCategories = categoryViewModel.getUniqueMainCategories();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height *
            0.4, // Limit dropdown height to 40% of screen height
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        color: Theme.of(context).colorScheme.background,
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
                        categoryViewModel.getMainCategoryIdByName(mainCategory))
                    .map((subCategoryName) => ListTile(
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
                        ))
                    .toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

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

  // Show the popup for editing sensor details
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

    // Use local state within the dialog for selected category values
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
                          labelText: AppLocale.Sensor.getString(context)),
                    ),
                    SizedBox(height: 10),
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
                          selectedSubCategory = null; // Reset subcategory
                        });
                      },
                      items: uniqueMainCategories
                          .map((mainCategory) => DropdownMenuItem<String>(
                                value: mainCategory,
                                child: Text(mainCategory),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      value: selectedSubCategory,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSubCategory = newValue;
                        });
                      },
                      items: subCategoriesForSelectedMain
                          .map((subCategory) => DropdownMenuItem<String>(
                                value: subCategory,
                                child: Text(subCategory),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _thresholdController,
                      decoration: InputDecoration(
                          labelText: AppLocale.Threshold.getString(context)),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _consumptionController,
                      decoration: InputDecoration(
                          labelText: AppLocale.Consommation.getString(context)),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _durationController,
                      decoration: InputDecoration(
                          labelText: AppLocale.Duration.getString(context)),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocale.Cancel.getString(context),
                    style: TextStyles.txtBtnNOStyle(blue),
                  ),
                ),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Theme.of(context).colorScheme.tertiaryFixed),
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

                      Navigator.of(context).pop();
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
                      print('Error updating sensor: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocale.Error.getString(context) + ' $error',
                            style: TextStyle(color: white),
                          ),
                          backgroundColor: red,
                        ),
                      );
                    }
                  },
                  child: Text(AppLocale.Save.getString(context),
                      style: TextStyles.txtBtnNOStyle(white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
