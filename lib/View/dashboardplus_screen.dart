import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/date_navbutton.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class DashPlus extends StatefulWidget {
  const DashPlus({super.key});

  @override
  State<DashPlus> createState() => _DashPlusState();
}

class _DashPlusState extends State<DashPlus> {
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
                AppLocale.Consommation.getString(context),
                style: TextStyles.appBarHeaderStyle(
                  Theme.of(context).colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              DateNavigationButton(),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    AppLocale.Highlights.getString(context),
                    style: TextStyles.subtitle2Style(
                      Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 350,
                height: 150,
                child: Container(
                  margin: EdgeInsets.only(top: 10, right: 7, left: 7),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                            height: 7,
                          ),
                          SizedBox(
                            width: 323,
                            child: Text(
                              AppLocale.HighlightParagraph.getString(context),
                              style: TextStyles.subtitle5Style(
                                Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: 350,
                height: 120,
                child: Container(
                  margin: EdgeInsets.only(top: 10, right: 7, left: 7),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                            height: 7,
                          ),
                          SizedBox(
                            width: 323,
                            child: Text(
                              AppLocale.HighlightParagraph2.getString(context),
                              style: TextStyles.subtitle5Style(
                                Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
