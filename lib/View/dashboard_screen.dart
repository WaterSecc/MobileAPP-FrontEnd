import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/circulardesign.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
import 'package:watersec_mobileapp_front/View/components/languagedrop_button.dart';
import 'package:watersec_mobileapp_front/View/components/textBtnNotOutlined.dart';
import 'package:watersec_mobileapp_front/View/components/text_button.dart';
import 'package:watersec_mobileapp_front/ViewModel/DashboardViewModel.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _dashboardViewModel = DashboardViewModel();
  

  late String _page = AppLocale.Dashboard.getString(context);
  final DateTime currentTime = DateTime.now();
  final DateFormat hourFormat = DateFormat('hh');
  final DateFormat amPmFormat = DateFormat('a');
  bool _isLoading = true;

  double _currentWaterConsumption = 0.0;
  double _waterConsumptionPercentage = 0.0;
  double _quarterWaterConsumption = 0.0;
  double _quarterwaterConsumptionPercentage = 0.0;

  double _sonedeAmount = 0.0;
  double _onasAmount = 0.0;
  double _totalAmount = 0.0;
  double _consumptionPercentLevel = 0.0;
  double _consumptionLevel = 0;

  @override
  void initState() {
    super.initState();
    _fetchDataDaily();
    _fetchDataQuarter();
    _fetchInvoices();
  }

  Future<void> _fetchDataDaily() async {
    setState(() {
      _isLoading = true;
    });
    await _dashboardViewModel.fetchDailyWaterConsumption(context);
    setState(() {
      _isLoading = false;
      _currentWaterConsumption = _dashboardViewModel.currentWaterConsumption;
      _waterConsumptionPercentage =
          _dashboardViewModel.waterConsumptionPercentage;
    });
  }

  Future<void> _fetchDataQuarter() async {
    await _dashboardViewModel.fetchQuarterWaterConsumption(context);
    setState(() {
      _quarterWaterConsumption = _dashboardViewModel.quarterWaterConsumption;
      _quarterwaterConsumptionPercentage =
          _dashboardViewModel.quarterwaterConsumptionPercentage;
    });
  }

  Future<void> _fetchInvoices() async {
    await _dashboardViewModel.fetchInvoices(context);
    setState(() {
      _sonedeAmount = _dashboardViewModel.sonedeAmount;
      _onasAmount = _dashboardViewModel.onasAmount;
      _totalAmount = _dashboardViewModel.totalAmount;
      _consumptionPercentLevel = _dashboardViewModel.consumptionPercentLevel;
      _consumptionLevel = _dashboardViewModel.consumptionLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: MyAppBar(page: AppLocale.Dashboard.getString(context)),
        ),
        body: Skeletonizer(
          enabled: _isLoading,
          ignoreContainers: true,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  MyCircularDesign(
                      consommationtxt:
                          AppLocale.Consommationtoday.getString(context),
                      consommationInt: _currentWaterConsumption,
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
                              _waterConsumptionPercentage.toString() +
                                  '% ' +
                                  AppLocale.Moyenne.getString(context),
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
                                    _quarterwaterConsumptionPercentage
                                            .toString() +
                                        '% ' +
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
                                _quarterWaterConsumption.toString() + 'L',
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
                    top: 490,
                    left: 30,
                    child: SizedBox(
                      width: 245,
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
                                      _totalAmount.toString() + ' TND',
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
                                      _sonedeAmount.toString() + ' TND',
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
                                      _onasAmount.toString() + ' TND',
                                      style: TextStyles.subtitle5Style(
                                        Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 490,
                    left: 265,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 10, right: 10, left: 10, bottom: 10),
                      
                      child: SizedBox(
                        width: 90,
                        height: 90,
                        child: LiquidCircularProgressIndicator(
                          backgroundColor: Theme.of(context).colorScheme.background,
                          borderColor: blue,
                          borderWidth: 2,
                          value: _consumptionPercentLevel.toDouble() / 100.0,
                          valueColor: AlwaysStoppedAnimation(blue),
                          center: Text(
                            '  ' +
                                _consumptionPercentLevel.toInt().toString() +
                                '%\n' +
                                AppLocale.Level.getString(context) +
                                ' ' +
                                _consumptionLevel.toInt().toString(),
                            style: TextStyles.palierStyle(
                              Theme.of(context).colorScheme.secondary,
                            ),
                          ),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


