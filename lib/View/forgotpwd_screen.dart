import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:watersec_mobileapp_front/View/login_screen.dart';

class ForgotPwd extends StatefulWidget {
  const ForgotPwd({super.key});

  @override
  State<ForgotPwd> createState() => _ForgotPwdState();
}

class _ForgotPwdState extends State<ForgotPwd> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Row(
            children: [
              SizedBox(
                width: 15,
              )
            ],
          ),
        ),
        body: Form(
            child: Stack(
          children: [
            SizedBox(
              height: 40,
            ),
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
              padding: EdgeInsets.only(top: 360, left: 55),
              child: Column(
                children: [
                  Container(
                    width: 285,
                    child: Text(
                      'Veuillez saisir l adresse e-mail associée à votre compte et nous vous enverrons un lien pour réinitialiser votre mot de passe.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: 260,
                    height: 48,
                    child: TextFormField(
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary,),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.background,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          hintText: "Adresse e-mail",
                          hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.normal,
                              fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 260,
                    height: 48,
                    child: FilledButton(
                      onPressed: () {},
                      child: Text(
                        'Envoyer',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Theme.of(context).cardColor,)),
                    ),
                  ),
                ],
              ),
            ))
          ],
        )),
      ),
    );
  }
}
