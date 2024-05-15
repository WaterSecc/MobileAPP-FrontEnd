import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/circulardesign.dart';
import 'package:watersec_mobileapp_front/View/components/dateselection_container.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
import 'package:watersec_mobileapp_front/View/custompopup.dart';

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
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
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
                                size: 15,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                '${dformat.format(_selectedDate1!)} ${dformat.format(_selectedDate2!)}',
                                style: TextStyle(
                                  color: Color.fromRGBO(90, 90, 90, 1),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
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
                                style: TextStyle(
                                  color: Color.fromRGBO(90, 90, 90, 1),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromRGBO(255, 255, 255, 1)),
                        shadowColor: MaterialStatePropertyAll<Color>(
                            Color.fromRGBO(51, 132, 198, 1)),
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(
                            color: Color.fromRGBO(51, 132, 198,
                                1), // Set the border color to blue
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
                    child: Card.outlined(
                      child: Column(
                        children: [
                          Text(
                            'Consommation moyenne par jour',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '4,569 L',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 25,
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
                                  color: Color.fromRGBO(51, 132, 198, 1),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Froid: ' + '526.18 Litres',
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
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
                                  color: Color.fromRGBO(249, 65, 68, 1),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Chaud: ' + '526.18 Litres',
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
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
                    child: Card.outlined(
                      child: Column(
                        children: [
                          Text(
                            'Consommation moyenne par utilisation',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '1.73 L',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 25,
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
                                  color: Color.fromRGBO(51, 132, 198, 1),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Froid: ' + '1.98  Litres',
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
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
                                  color: Color.fromRGBO(249, 65, 68, 1),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Chaud: ' + '1.36 Litres',
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
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
