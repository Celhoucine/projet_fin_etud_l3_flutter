import 'package:flutter/material.dart';
import 'package:projet_fin_etud_l3_flutter/register_agent.dart';
import 'package:projet_fin_etud_l3_flutter/register_client.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  @override
  final _RegisterClientForm = new GlobalKey<FormState>();
  late var formData = _RegisterClientForm.currentState;
  bool modeClient = true;
  bool modeAgency = false;
  bool obscureText = true;
  bool obscureText1 = true;
  
 
  
  Widget build(BuildContext context) {
    final Screenwidth = MediaQuery.of(context).size.width;
    final Screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: Screenheight * 0.037),
                  Container(
                    width: Screenwidth * 0.60,
                    height: Screenheight * 0.25,
                    child: Image(
                      image: AssetImage('assets/logo3.webp'),
                    ),
                  ),
                  SizedBox(
                    height: Screenheight * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: Screenheight * 0.01,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              modeClient = true;
                              modeAgency = false;
                            });
                          },
                          child: Container(
                            height: Screenheight*0.05,
                            width:Screenwidth*0.4,
                            child: Center(child: Text('Client'))),
                        ),
                        
                        InkWell(
                          
                          onTap: () {
                            setState(() {
                              modeAgency = true;
                              modeClient = false;
                            });
                          },
                          child: Container(
                            
                            height: Screenheight*0.05,
                            width:Screenwidth*0.4,
                            child: Center(child: Text('Agency'))),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 2,
                          color: modeClient
                              ? Color.fromRGBO(6, 64, 64, 1)
                              : Color.fromRGBO(84, 140, 129, 100),
                          width: Screenwidth * 0.4),
                      Container(
                          height: 2,
                          color: modeAgency
                              ? Color.fromRGBO(6, 64, 64, 1)
                              : Color.fromRGBO(84, 140, 129, 100),
                          width: Screenwidth * 0.4),
                    ],
                  ),
                  Visibility(visible: modeClient, child: Client()),
                  Visibility(visible: modeAgency, child: Agency())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
