import 'package:flutter/material.dart';
import 'package:watersec_mobileapp_front/View/components/text_field.dart';
import 'package:watersec_mobileapp_front/View/forgotpwd_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
          body: Form(
              //key: _keyForm,
              child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 5, top: 20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width,
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 370, left: 65),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 260,
                      height: 48,
                      child: MyTextField(hint: 'Adresse e-mail')),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 260,
                    height: 48,
                    child: MyTextField(
                      hint: 'Mot De Passe',
                    ),
                    /*prefixIcon: Visibility(
                          visible: true,
                          child: Icon(
                            Icons.lock,
                            color: Color.fromRGBO(90, 90, 90, 1),
                          ),
                        ),*/
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 260,
                    height: 48,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/dashboard');
                      },
                      child: Text(
                        'SE CONNECTER',
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
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 260,
                    height: 48,
                    child: TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/forgotpwd');
                      },
                      child: Text(
                        'Mot De Passe Oublié?',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color.fromRGBO(51, 132, 198, 1),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ))),
    );
  }
}
