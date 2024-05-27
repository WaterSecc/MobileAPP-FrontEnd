import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/circulardesign.dart';
import 'package:watersec_mobileapp_front/View/components/dateselection_container.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
import 'package:watersec_mobileapp_front/View/custompopup.dart';
import 'package:watersec_mobileapp_front/colors.dart';
import 'package:watersec_mobileapp_front/theme/textStyles.dart';

class Analyses extends StatefulWidget {
  const Analyses({Key? key}) : super(key: key);

  @override
  State<Analyses> createState() => _AnalysesState();
}

class _AnalysesState extends State<Analyses> {
  late final String _page = 'Analyses';
  List<String> selectedTags = [];
  DateTime? _selectedDate1;
  DateTime? _selectedDate2;
  final DateFormat dformat = DateFormat('dd/MM/yyyy');
  late final CalendarContainer calendarContainer;

  @override
  void initState() {
    super.initState();
    _selectedDate1 = DateTime.now();
    _selectedDate2 = DateTime.now().subtract(const Duration(days: 30));
    calendarContainer = CalendarContainer(
      selectedDate1: _selectedDate1,
      selectedDate2: _selectedDate2,
    );
  }

  void _onFiltersSelected(List<String> tags) {
    setState(() {
      selectedTags = tags;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
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
                Positioned(
                    top: 3,
                    left: 45,
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomPopup(
                              onFiltersSelected: _onFiltersSelected,
                              defaultTagText: 'Default Tag',
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.sliders,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 15,
                              ),
                              SizedBox(
                                width: 17,
                              ),
                              Text(
                                '${dformat.format(_selectedDate1!)} ${dformat.format(_selectedDate2!)}',
                                style: TextStyles.subtitle3Style(
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                selectedTags.isNotEmpty
                                    ? selectedTags.join(', ')
                                    : 'Filtrer par tag',
                                style: TextStyles.subtitle4Style(
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          Theme.of(context).colorScheme.background,
                        ),
                        shadowColor: MaterialStatePropertyAll<Color>(blue),
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary, // Set the border color to blue
                            width:
                                1.3, // Set the border width (adjust as needed)
                          ),
                        ),
                        fixedSize: MaterialStatePropertyAll(Size(310, 47)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 65),
                  child: MyCircularDesign(
                      consommationtxt: 'Consommation totale:',
                      consommationInt: 9.93,
                      chaud: 6.84,
                      froid: 3.09),
                ),
                Positioned(
                  top: 470,
                  left: 30,
                  child: SizedBox(
                    width: 340,
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
                            'Consommation moyenne par jour',
                            style: TextStyles.subtitle5Style(
                              Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Text(
                            '4,569 L',
                            style: TextStyles.Header1Style(
                              Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: blue,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Froid: ' + '526.18 Litres',
                                style: TextStyles.subtitle6Style(
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: red,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Chaud: ' + '526.18 Litres',
                                style: TextStyles.subtitle6Style(
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 580,
                  left: 30,
                  child: SizedBox(
                    width: 340,
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
                            'Consommation moyenne par utilisation',
                            style: TextStyles.subtitle5Style(
                              Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          Text(
                            '1.73 L',
                            style: TextStyles.Header1Style(
                              Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: blue,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Froid: ' + '1.98  Litres',
                                style: TextStyles.subtitle6Style(
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: red,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Chaud: ' + '1.36 Litres',
                                style: TextStyles.subtitle6Style(
                                  Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          )
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
    );
  }
}
