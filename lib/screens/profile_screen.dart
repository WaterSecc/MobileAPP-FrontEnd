import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watersec_mobileapp_front/constants/app_bar.dart';
import 'package:watersec_mobileapp_front/constants/drawer.dart';
import 'package:watersec_mobileapp_front/constants/languagedrop_button.dart';
import 'package:watersec_mobileapp_front/constants/phonenumber_ddbtn.dart';
import 'package:watersec_mobileapp_front/constants/text_field.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String _page = 'Profil';
  final List<String> phoneCodesList = [
    '+ 20',
    '+ 33',
    '+ 49',
    '+ 30',
    '+ 39',
    '+ 961',
    '+ 218',
    '+ 212',
    '+ 31',
    '+ 966',
    '+ 41',
    '+ 216',
  ];

  String selectedPhone = '+ 216';
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
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 300,
                      height: 160,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: Ink(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/azizatar.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 130,
                        left: 180,
                        child: Container(
                          height: 35,
                          width: 35,
                          child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                FontAwesomeIcons.image,
                                color: Color.fromRGBO(0, 0, 0, 1),
                              )),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 33,
                  ),
                  SizedBox(
                      width: 160,
                      height: 44,
                      child: MyTextField(hint: 'Prénom')),
                  SizedBox(
                    width: 7,
                  ),
                  SizedBox(
                      width: 160, height: 44, child: MyTextField(hint: 'Nom')),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                  width: 327,
                  height: 44,
                  child: MyTextField(hint: 'Adresse e-mail')),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                  width: 327,
                  height: 44,
                  child: MyTextField(hint: 'Nom d’Entreprise')),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 33,
                  ),
                  SizedBox(
                      width: 160,
                      height: 44,
                      child: MyTextField(hint: 'Nombre Employés')),
                  SizedBox(
                    width: 7,
                  ),
                  SizedBox(
                      width: 160,
                      height: 44,
                      child: Container(
                        width: 160,
                        height: 44,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(90, 90, 90, 1),
                                style: BorderStyle.solid,
                                width: 0.7),
                            borderRadius: BorderRadius.all(Radius.circular(9))),
                        child: Center(child: MyDropdownMenu()),
                      )),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 327,
                height: 44,
                child: Container(
                  width: 327,
                  height: 44,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(90, 90, 90, 1),
                          style: BorderStyle.solid,
                          width: 0.7),
                      borderRadius: BorderRadius.all(Radius.circular(9))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 3,
                      ),
                      MyPhoneNumberDDButton(
                          phoneCodes: phoneCodesList,
                          selectedPhoneCode: selectedPhone),
                      SizedBox(
                        width: 257,
                        child: TextFormField(
                          style:
                              TextStyle(color: Color.fromRGBO(90, 90, 90, 1)),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromRGBO(255, 255, 255, 1),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                            hintText: 'Numéro Téléphone',
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(90, 90, 90, 1),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 33,
                  ),
                  SizedBox(
                      width: 160,
                      height: 44,
                      child: MyTextField(hint: 'Position')),
                  SizedBox(
                    width: 7,
                  ),
                  SizedBox(
                      width: 160,
                      height: 44,
                      child: MyTextField(hint: 'Code Postale')),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: 207,
                  height: 38,
                  child: FilledButton(
                    onPressed: () {},
                    child: Text(
                      'Enregistrer',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromRGBO(51, 132, 198, 1))),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 220,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/changepwd');
                    },
                    child: Text(
                      'Changer Mot De Passe',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        color: Color.fromRGBO(51, 132, 198, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
