import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lottie/lottie.dart';

class failedpage extends StatefulWidget {
  const failedpage({ Key? key }) : super(key: key);

  @override
  State<failedpage> createState() => _failedpageState();
}

class _failedpageState extends State<failedpage> {
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
            SizedBox(height: ScreenHeight * 0.15),
            Lottie.asset(
              'assets/failed.json',
              repeat: false,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                'Process Has Failed',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text('something went wrong please try again later'),
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
    ));
  }
}
