import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lottie/lottie.dart';
import 'package:projet_fin_etud_l3_flutter/agence/home_agence.dart';

class success extends StatefulWidget {
  const success({Key? key}) : super(key: key);

  @override
  State<success> createState() => _successState();
}

class _successState extends State<success> {
  @override
  Widget build(BuildContext context) {
    return success();
  }

  Widget success() {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      body: ListView(
        children: [
          Container(
            width: ScrrenWidth,
            height: ScreenHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: ScreenHeight * 0.2),
                Lottie.asset(
                  'assets/972-done.json',
                  repeat: false,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(
                    'Successfull',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text('Your information are update successfull'),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: ScrrenWidth * 0.4,
                    child: NeumorphicButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('home_agence');
                      },
                      child: Center(
                        child: Text(
                          'Done',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      style: NeumorphicStyle(
                          color: Color.fromRGBO(84, 140, 129, 1),
                          shape: NeumorphicShape.convex,
                          depth: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
