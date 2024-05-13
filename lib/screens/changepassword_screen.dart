import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/constants/filled_button.dart';
import 'package:watersec_mobileapp_front/constants/text_field.dart';

class ChangePwd extends StatefulWidget {
  const ChangePwd({super.key});

  @override
  State<ChangePwd> createState() => _ChangePwdState();
}

class _ChangePwdState extends State<ChangePwd> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          title: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Text(
                'Changer Mot De Passe',
                style: TextStyle(
                  fontFamily: 'Monda',
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Color.fromRGBO(90, 90, 90, 1),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 210,
                ),
                SizedBox(
                    height: 44,
                    width: 251,
                    child: MyTextField(hint: 'Ancien Mot De Passe')),
                SizedBox(height: 15),
                SizedBox(
                    height: 44,
                    width: 251,
                    child: MyTextField(hint: 'Nouveau Mot De Passe')),
                SizedBox(height: 15),
                SizedBox(
                    height: 44,
                    width: 251,
                    child: MyTextField(hint: 'Confirmer Mot De Passe')),
                SizedBox(height: 15),
                SizedBox(
                    height: 37,
                    width: 195,
                    child: MyFilledButton(text: 'Enregistrer')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
