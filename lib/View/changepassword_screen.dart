import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/filled_button.dart';
import 'package:watersec_mobileapp_front/View/components/text_field.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

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
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.secondary,
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Text(
                AppLocale.ChangePwd.getString(context),
                style: TextStyles.appBarHeaderStyle(
                  Theme.of(context).colorScheme.secondary,
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
                    child: MyTextField(hint: AppLocale.OldPwd.getString(context))),
                SizedBox(height: 15),
                SizedBox(
                    height: 44,
                    width: 251,
                    child: MyTextField(hint: AppLocale.NewPwd.getString(context))),
                SizedBox(height: 15),
                SizedBox(
                    height: 44,
                    width: 251,
                    child: MyTextField(hint: AppLocale.ConfirmPwd.getString(context))),
                SizedBox(height: 35),
                SizedBox(
                    height: 37,
                    width: 195,
                    child: MyFilledButton(
                      text: AppLocale.Save.getString(context),
                      onPressed: () {},
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
