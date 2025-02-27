import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/qrcode_btn.dart';
import 'package:watersec_mobileapp_front/View/components/text_button.dart';
import 'package:watersec_mobileapp_front/View/components/text_field.dart';
import 'package:watersec_mobileapp_front/ViewModel/settingsGETViewModel.dart';
import 'package:watersec_mobileapp_front/colors.dart';

class ThresholdScreen extends StatefulWidget {
  final int currentThreshold; // Receive current global threshold

  const ThresholdScreen({Key? key, required this.currentThreshold})
      : super(key: key);

  @override
  State<ThresholdScreen> createState() => _ThresholdScreenState();
}

class _ThresholdScreenState extends State<ThresholdScreen> {
  late TextEditingController _thresholdController;

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingController with the current threshold
    _thresholdController =
        TextEditingController(text: widget.currentThreshold.toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close the keyboard if the user taps outside of the text field
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // This ensures the sheet will resize when keyboard is shown
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Adjust the height based on the content
            children: [
              SizedBox(height: 30),
              Center(
                child: Text(
                  AppLocale.GlobalConsumptionThreshold.getString(context),
                  style: TextStyle(
                    fontFamily: 'Monda',
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 35, left: 45, right: 35, bottom: 25),
                child: Text(
                  AppLocale.ThresholdExplain.getString(context),
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              SizedBox(
                width: 268,
                height: 44,
                child: MyTextField(
                  hint: AppLocale.Threshold.getString(context) + ' (L)',
                  controller:
                      _thresholdController, // Show current threshold in the field
                  onChanged: (String) {}, // Handle changes if necessary
                ),
              ),
              SizedBox(height: 26),
              Row(
                children: [
                  SizedBox(width: 46),
                  SizedBox(
                    height: 38,
                    width: 150,
                    child: MyTextBtn(
                      text: AppLocale.Cancel.getString(context),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 150,
                    height: 38,
                    child: FilledButton(
                      onPressed: () async {
                        // Save the updated threshold here, and close the bottom sheet
                        int updatedThreshold =
                            int.tryParse(_thresholdController.text) ??
                                widget.currentThreshold;

                        // Call method in ViewModel to save updatedThreshold
                        bool isSuccess = await Provider.of<SettingsViewModel>(
                                context,
                                listen: false)
                            .updateGlobalThreshold(updatedThreshold);

                        // Show success or error Snackbar based on the result
                        if (isSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Global threshold updated successfully!'),
                              backgroundColor: green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Failed to update global threshold. Please try again.'),
                              backgroundColor: red,
                            ),
                          );
                        }

                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: Text(
                        AppLocale.Save.getString(context),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Theme.of(context).colorScheme.tertiaryFixed),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
