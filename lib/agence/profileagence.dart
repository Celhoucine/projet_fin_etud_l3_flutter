import 'package:flutter/material.dart';

class profileagence extends StatefulWidget {
  const profileagence({Key? key}) : super(key: key);

  @override
  State<profileagence> createState() => _profileagenceState();
}

class _profileagenceState extends State<profileagence> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 200,
        child: Text('Profile',style: TextStyle(fontSize: 40),),
      ),
    );
  }
}
