import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/filled_button.dart';
import 'package:watersec_mobileapp_front/ViewModel/devicesViewModel.dart';
import 'package:watersec_mobileapp_front/View/components/dateselection_container.dart';
import 'package:watersec_mobileapp_front/View/components/text_button.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class CustomPopup extends StatefulWidget {
  final Function(List<Map<String, String>>, DateTime, DateTime)
      onFiltersAndDatesSelected;
  final String defaultTagText;

  const CustomPopup({
    Key? key,
    required this.onFiltersAndDatesSelected,
    required this.defaultTagText,
  }) : super(key: key);

  @override
  State<CustomPopup> createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  bool _isTagContainerOpen = false;
  List<Map<String, String>> selectedFloors = [];
  DateTime _selectedStartDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _selectedEndDate = DateTime.now();
  final DateFormat dformat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  Future<void> _fetchDevices() async {
    await Provider.of<DevicesViewModel>(context, listen: false)
        .fetchDevices(context);
  }

  void _onDatesSelected(DateTime startDate, DateTime endDate) {
    setState(() {
      _selectedStartDate = startDate;
      _selectedEndDate = endDate;
    });
  }

  void _toggleTagContainer() {
    setState(() {
      _isTagContainerOpen = !_isTagContainerOpen;
    });
  }

  Future<void> _handleApplyFiltersAndNavigateBack() async {
    widget.onFiltersAndDatesSelected(
      selectedFloors,
      _selectedStartDate,
      _selectedEndDate,
    );
    Navigator.of(context).pop();
  }

  void _selectFloor(String buildingName, String floorName, String floorId) {
    final floorData = {
      "buildingName": buildingName,
      "floorName": floorName,
      "floorId": floorId,
    };

    setState(() {
      if (selectedFloors.any((f) => f["floorId"] == floorId)) {
        selectedFloors.removeWhere((f) => f["floorId"] == floorId);
      } else {
        selectedFloors.add(floorData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width;
    final dialogHeight = screenSize.height * 0.85;

    final devicesViewModel = context.watch<DevicesViewModel>();
    final buildings = devicesViewModel.buildings;

    return Dialog(
      insetPadding: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: Theme.of(context).colorScheme.background,
        ),
        width: dialogWidth,
        height: dialogHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            if (buildings.isEmpty)
              Center(
                child: Text('No floors available for selected water meters.'),
              )
            else
              Container(
                width: dialogWidth,
                height: _isTagContainerOpen ? dialogHeight * 0.23 : 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    width: 0.3,
                    style: BorderStyle.solid,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: _toggleTagContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(AppLocale.filtrer.getString(context),
                                textAlign: TextAlign.left,
                                style: TextStyles.Header4Style(
                                    Theme.of(context).colorScheme.secondary)),
                          ),
                        ),
                      ),
                      if (_isTagContainerOpen)
                        Expanded(
                          child: ListView.builder(
                            itemCount: buildings.length,
                            itemBuilder: (context, index) {
                              final building = buildings[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 4.0),
                                    child: Text(
                                      building.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: building.floors.length,
                                    itemBuilder: (context, floorIndex) {
                                      final floor = building.floors[floorIndex];
                                      final isSelected = selectedFloors.any(
                                          (f) =>
                                              f["floorId"] ==
                                              floor.id.toString());

                                      return GestureDetector(
                                        onTap: () => _selectFloor(building.name,
                                            floor.name, floor.id.toString()),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.grey[300]
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .background,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              floor.name,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                                color: isSelected
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 3),
            Container(
              width: dialogWidth,
              height: dialogHeight * 0.65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  width: 0.3,
                  style: BorderStyle.solid,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(AppLocale.filtrerdate.getString(context),
                          textAlign: TextAlign.left,
                          style: TextStyles.Header4Style(
                              Theme.of(context).colorScheme.secondary)),
                    ),
                  ),
                  CalendarContainer(
                    selectedDate1: _selectedStartDate,
                    selectedDate2: _selectedEndDate,
                    onDateRangeSelected: _onDatesSelected,
                  ),
                ],
              ),
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.0),
                    child: SizedBox(
                      height: 38,
                      child: MyFilledButton(
                        onPressed: _handleApplyFiltersAndNavigateBack,
                        text: AppLocale.Apply.getString(context),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.0),
                    child: SizedBox(
                      height: 38,
                      child: MyTextBtn(
                        text: AppLocale.Cancel.getString(context),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
