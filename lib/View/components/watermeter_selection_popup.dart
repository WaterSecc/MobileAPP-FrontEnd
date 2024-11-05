import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/filled_button.dart';
import 'package:watersec_mobileapp_front/View/components/textBtnNotOutlined.dart';
import 'package:watersec_mobileapp_front/ViewModel/devicesViewModel.dart';
import 'package:watersec_mobileapp_front/ViewModel/watermeterViewModel.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class WaterMeterSelectionPopup extends StatefulWidget {
  final Function(List<String> selectedMeterIds) onMetersSelected;

  WaterMeterSelectionPopup({required this.onMetersSelected});

  @override
  _WaterMeterSelectionPopupState createState() =>
      _WaterMeterSelectionPopupState();
}

class _WaterMeterSelectionPopupState extends State<WaterMeterSelectionPopup> {
  late List<bool> _selectedMeters;
  late List<String> _selectedMeterIds;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<WaterMetersViewModel>(context, listen: false);

    // Initialize the selection state based on previously selected meters
    _selectedMeters = List.generate(
      viewModel.watermeters.length,
      (index) => viewModel.selectedMeterIds
          .contains(viewModel.watermeters[index].identifier),
    );

    // Initialize the selected meter IDs
    _selectedMeterIds = List.from(viewModel.selectedMeterIds);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterMetersViewModel>(
      builder: (context, viewModel, child) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocale.selectWaterMeters.getString(context),
                  style: TextStyles.ListHeaderStyle(
                    Theme.of(context).colorScheme.secondary,
                  ),
                ),
                SizedBox(height: 20),
                if (viewModel.watermeters.isEmpty)
                  Center(
                      child: Text(
                    AppLocale.noWaterMeters.getString(context),
                    style: TextStyles.Header1Style(
                      Theme.of(context).colorScheme.secondary,
                    ),
                  ))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.watermeters.length,
                      itemBuilder: (context, index) {
                        final meter = viewModel.watermeters[index];
                        return CheckboxListTile(
                          title: Text(meter.name),
                          value: _selectedMeters[index],
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedMeters[index] = value ?? false;
                              if (_selectedMeters[index]) {
                                _selectedMeterIds.add(meter.identifier);
                              } else {
                                _selectedMeterIds.remove(meter.identifier);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTxtBtnNotOutlined(
                      text: AppLocale.clearall.getString(context),
                      onPressed: () {
                        setState(() {
                          _selectedMeters = List.generate(
                              viewModel.watermeters.length, (index) => false);
                          _selectedMeterIds.clear();
                        });
                      },
                    ),
                    MyTxtBtnNotOutlined(
                      onPressed: () {
                        setState(() {
                          _selectedMeters = List.generate(
                              viewModel.watermeters.length, (index) => true);
                          _selectedMeterIds = viewModel.watermeters
                              .map((meter) => meter.identifier)
                              .toList();
                        });
                      },
                      text: AppLocale.selectall.getString(context),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: MyFilledButton(
                    text: AppLocale.Save.getString(context),
                    onPressed: () {
                      widget.onMetersSelected(_selectedMeterIds);
                      viewModel.updateSelectedMeters(
                          _selectedMeterIds); // Save the selected meters
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
