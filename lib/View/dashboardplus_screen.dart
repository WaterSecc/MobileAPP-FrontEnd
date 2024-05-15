import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/View/components/date_navbutton.dart';

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
          title: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Text(
                'Consommation',
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
                    'Points Clés',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Color.fromRGBO(0, 0, 0, 1),
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
                child: Card.outlined(
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
                          Text(
                            'Jusqu\'à présent, vous utilisez moins d\'eau\n'
                            'que d\'habitude.',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
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
                child: Card.outlined(
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
                          Text(
                            'En moyenne, vous utilisez moins d\'eau cette\n'
                            'année que l\'année dernière.',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
