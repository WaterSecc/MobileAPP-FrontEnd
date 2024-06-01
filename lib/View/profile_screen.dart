import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watersec_mobileapp_front/Localization/locales.dart';
import 'package:watersec_mobileapp_front/View/components/app_bar.dart';
import 'package:watersec_mobileapp_front/View/components/drawer.dart';
import 'package:watersec_mobileapp_front/View/components/filled_button.dart';
import 'package:watersec_mobileapp_front/View/components/languagedrop_button.dart';
import 'package:watersec_mobileapp_front/View/components/phonenumber_ddbtn.dart';
import 'package:watersec_mobileapp_front/View/components/textBtnNotOutlined.dart';
import 'package:watersec_mobileapp_front/View/components/text_field.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String _page = AppLocale.Profile.getString(context);
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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
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
                                color: Theme.of(context).colorScheme.secondary,
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
                      child:
                          MyTextField(hint: AppLocale.Name.getString(context))),
                  SizedBox(
                    width: 7,
                  ),
                  SizedBox(
                      width: 160,
                      height: 44,
                      child: MyTextField(
                          hint: AppLocale.LastName.getString(context))),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                  width: 327,
                  height: 44,
                  child: MyTextField(hint: AppLocale.Email.getString(context))),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                  width: 327,
                  height: 44,
                  child:
                      MyTextField(hint: AppLocale.Company.getString(context))),
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
                      child: MyTextField(
                          hint: AppLocale.Employees.getString(context))),
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
                                color: Theme.of(context).colorScheme.secondary,
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
                          color: Theme.of(context).colorScheme.secondary,
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
                        width: 251.5,
                        child: TextFormField(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.background,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                            hintText: AppLocale.PhoneNumber.getString(context),
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
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
                      child: MyTextField(
                          hint: AppLocale.Position.getString(context))),
                  SizedBox(
                    width: 7,
                  ),
                  SizedBox(
                      width: 160,
                      height: 44,
                      child: MyTextField(
                          hint: AppLocale.ZIPCode.getString(context))),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: 207,
                  height: 38,
                  child: MyFilledButton(
                      text: AppLocale.Save.getString(context),
                      onPressed: () {}),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 220,
                  ),
                  MyTxtBtnNotOutlined(
                    onPressed: () {
                      Navigator.pushNamed(context, '/changepwd');
                    },
                    text: AppLocale.ChangePwd.getString(context),
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
