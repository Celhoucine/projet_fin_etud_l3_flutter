import 'package:flutter/material.dart';

class addpost extends StatefulWidget {
  const addpost({Key? key}) : super(key: key);

  @override
  State<addpost> createState() => _addpostState();
}

class _addpostState extends State<addpost> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 200,
        child: Text('Add Offer',style: TextStyle(fontSize: 40),),
      ),
    );
  }
}
