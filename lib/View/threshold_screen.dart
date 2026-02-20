import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';

import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/text_button.dart'; // MyTextBtn
import 'package:watersec_mobileapp_front/View/components/text_field.dart'; // MyTextField
import 'package:watersec_mobileapp_front/ViewModel/settingsGETViewModel.dart';
import 'package:watersec_mobileapp_front/colors.dart';

class ThresholdScreen extends StatefulWidget {
  final int currentThreshold;

  const ThresholdScreen({
    Key? key,
    required this.currentThreshold,
  }) : super(key: key);

  @override
  State<ThresholdScreen> createState() => _ThresholdScreenState();
}

class _ThresholdScreenState extends State<ThresholdScreen> {
  late TextEditingController _thresholdController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _thresholdController =
        TextEditingController(text: widget.currentThreshold.toString());
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    super.dispose();
  }

  int _safeParse() {
    final raw = _thresholdController.text.trim();
    final v = int.tryParse(raw);
    return v ?? widget.currentThreshold;
  }

  Future<void> _save() async {
    if (_saving) return;

    FocusScope.of(context).unfocus();

    final updatedThreshold = _safeParse();

    if (updatedThreshold < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Invalid threshold value."),
          backgroundColor: red,
        ),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final isSuccess =
          await Provider.of<SettingsViewModel>(context, listen: false)
              .updateGlobalThreshold(updatedThreshold);

      if (!mounted) return;

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Global threshold updated successfully!"),
            backgroundColor: green,
          ),
        );

        Navigator.pop(context, updatedThreshold);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                "Failed to update global threshold. Please try again."),
            backgroundColor: red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Drag handle
                  Center(
                    child: Container(
                      width: 70,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  // ── Title (like screenshot)
                  Text(
                    "Global Threshold",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'Montserrat',
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Description
                  Text(
                    AppLocale.ThresholdExplain.getString(context),
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.75),
                      fontFamily: 'Montserrat',
                    ),
                  ),

                  const SizedBox(height: 22),

                  // ── Input container (rounded, like screenshot)
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.25),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Global Consumption (L)",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.75),
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Use your exact component
                        MyTextField(
                          hint: "",
                          controller: _thresholdController,
                          onChanged: (String) {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  // ── Buttons row (pill buttons like screenshot)
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: FilledButton(
                            onPressed: _saving ? null : _save,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(newBlue),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                              ),
                            ),
                            child: _saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Save",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          // Use your predefined button, but style it as outline
                          child: OutlinedButton(
                            onPressed:
                                _saving ? null : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: newBlue, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: newBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
