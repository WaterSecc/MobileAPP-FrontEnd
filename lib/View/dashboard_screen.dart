import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/circulardesign.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
import 'package:watersec_mobileapp_front/View/components/languagedrop_button.dart';
import 'package:watersec_mobileapp_front/View/components/palier.dart';
import 'package:watersec_mobileapp_front/View/components/textBtnNotOutlined.dart';
import 'package:watersec_mobileapp_front/View/components/text_button.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String _page = AppLocale.Dashboard.getString(context);
  final DateTime currentTime = DateTime.now();
  final DateFormat hourFormat = DateFormat('hh');
  final DateFormat amPmFormat = DateFormat('a');
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: MyAppBar(page: _page),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                MyCircularDesign(
                    consommationtxt:
                        AppLocale.Consommationtoday.getString(context),
                    consommationInt: 137.64,
                    chaud: 25.09,
                    froid: 25.09),
                Positioned(
                  top: 350,
                  child: Center(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 70, left: 100),
                          child: Icon(
                            Icons.arrow_downward_sharp,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 70),
                          child: Text(
                            '-27.0% ' + AppLocale.Moyenne.getString(context),
                            style: TextStyles.subtitle3Style(
                              Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 450,
                  left: 30,
                  child: SizedBox(
                    width: 330,
                    height: 100,
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
                          Text(
                            AppLocale.ConsommationTrim.getString(context),
                            style: TextStyles.subtitle3Style(
                              Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                                height: 20,
                              ),
                              Container(
                                child: Icon(
                                  Icons.arrow_downward_sharp,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 10,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Container(
                                child: Text(
                                  '-27.0% ' +
                                      AppLocale.Moyenne.getString(context),
                                  style: TextStyles.subtitle4Style(
                                    Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                          Center(
                            child: Text(
                              '4,569 L',
                              style: TextStyles.Header1Style(
                                Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 560,
                  left: 30,
                  child: SizedBox(
                    width: 330,
                    height: 100,
                    child: Container(
                      margin: EdgeInsets.only(top: 10, right: 7, left: 7),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                      ),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    AppLocale.FraisT.getString(context),
                                    style: TextStyles.subtitle2Style(
                                      Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    '3.015 TND',
                                    style: TextStyles.subtitle2Style(
                                      Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    AppLocale.FraisS.getString(context),
                                    style: TextStyles.subtitle5Style(
                                      Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    '1 TND',
                                    style: TextStyles.subtitle5Style(
                                      Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    AppLocale.FraisO.getString(context),
                                    style: TextStyles.subtitle5Style(
                                      Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    '2.015 TND',
                                    style: TextStyles.subtitle5Style(
                                      Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          WaterLevelIndicator(
                            waterLevel: 0.5, // Water level between 0.0 and 1.0
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .background
                                .withOpacity(0.2), // Light grey background
                            waterColor: blue,
                            text: '50%',
                            textStyle: TextStyles.Header4Style(
                              Theme.of(context).colorScheme.secondary,
                            ),
                            strokeWidth: 2.0, // Stroke width for the frame
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 670,
                  left: 30,
                  child: SizedBox(
                    width: 330,
                    height: 100,
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
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(AppLocale.Consommation.getString(context),
                                  style: TextStyles.subtitle2Style(
                                    Theme.of(context).colorScheme.secondary,
                                  )),
                              SizedBox(
                                width: 57,
                              ),
                              SizedBox(
                                  height: 40,
                                  child: MyTxtBtnNotOutlined(
                                    text: AppLocale.PlusDetails.getString(
                                            context) +
                                        ' >',
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/dashboardplus');
                                    },
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${hourFormat.format(currentTime)} ${amPmFormat.format(currentTime)}',
                                style: TextStyles.subtitle5Style(
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              SizedBox(
                                width: 160,
                              ),
                              SizedBox(
                                child: Icon(
                                  Icons.bar_chart_sharp,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '30L',
                                style: TextStyles.subtitle5Style(
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
