import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/View/components/qrcode_btn.dart';
import 'package:watersec_mobileapp_front/View/components/text_button.dart';
import 'package:watersec_mobileapp_front/View/components/text_field.dart';

class ThresholdScreen extends StatefulWidget {
  const ThresholdScreen({super.key});

  @override
  State<ThresholdScreen> createState() => _ThresholdScreenState();
}

class _ThresholdScreenState extends State<ThresholdScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              'Seuil Global',
              style: TextStyle(
                fontFamily: 'Monda',
                fontWeight: FontWeight.w900,
                fontSize: 22,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 35, left: 45, right: 35, bottom: 25),
            child: Text(
              'Veuillez saisir un seuil  global pour activer les alertes.',
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
              child: MyTextField(hint: 'Seuil global de consommation (L)')),
          SizedBox(
            height: 26,
          ),
          Row(
            children: [
              SizedBox(
                width: 47,
              ),
              SizedBox(
                width: 150,
                height: 38,
                child: FilledButton(
                  onPressed: () {},
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Theme.of(context).cardColor,)),
                ),
              ),
              SizedBox(
                width: 1,
              ),
              SizedBox(
                height: 38,
                width: 150,
                child: MyTextBtn(
                  text: 'Annuler',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
