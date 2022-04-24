import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lottie/lottie.dart';

class editeclientsuccess extends StatefulWidget {
  const editeclientsuccess({Key? key}) : super(key: key);

  @override
  State<editeclientsuccess> createState() => _editeclientsuccessState();
}

class _editeclientsuccessState extends State<editeclientsuccess> {
  @override
  Widget build(BuildContext context) {
    final ScrrenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      body: Container(
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
                    Navigator.of(context).pushNamed('profileclient');
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
    ));
  }
}
