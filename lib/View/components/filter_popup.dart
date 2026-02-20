import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/filled_button.dart';
import 'package:watersec_mobileapp_front/View/components/text_button.dart';
import 'package:watersec_mobileapp_front/ViewModel/devicesViewModel.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';
import 'package:provider/provider.dart';


class FiltersPopup extends StatefulWidget {
  final List<Map<String, String>> initialSelectedFloors;

  const FiltersPopup({
    required this.initialSelectedFloors,
  });

  @override
  State<FiltersPopup> createState() => FiltersPopupState();
}

class FiltersPopupState extends State<FiltersPopup> {
  bool _isOpen = true;
  late List<Map<String, String>> selectedFloors;

  @override
  void initState() {
    super.initState();
    selectedFloors = [...widget.initialSelectedFloors];
  }

  void _toggle() => setState(() => _isOpen = !_isOpen);

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
    final devicesViewModel = context.watch<DevicesViewModel>();
    final buildings = devicesViewModel.buildings;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 80),
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // header
            Row(
              children: [
                Text(
                  AppLocale.filtrer.getString(context),
                  style: TextStyles.Header4Style(
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 6),

            if (buildings.isEmpty)
              const Padding(
                padding: EdgeInsets.all(14.0),
                child: Text('No floors available for selected water meters.'),
              )
            else
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      width: 0.3,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "Buildings / Floors",
                          style: TextStyles.Header4Style(
                            Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        trailing: Icon(
                          _isOpen
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onTap: _toggle,
                      ),
                      if (_isOpen)
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
                                        vertical: 8.0, horizontal: 10.0),
                                    child: Text(
                                      building.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                  ...building.floors.map((floor) {
                                    final isSelected = selectedFloors.any(
                                      (f) => f["floorId"] == floor.id.toString(),
                                    );

                                    return GestureDetector(
                                      onTap: () => _selectFloor(
                                        building.name,
                                        floor.name,
                                        floor.id.toString(),
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.grey[300]
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          floor.name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  const SizedBox(height: 6),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: MyFilledButton(
                      onPressed: () => Navigator.pop(context, selectedFloors),
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
    );
  }
}
