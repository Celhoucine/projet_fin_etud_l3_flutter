import 'package:flutter/material.dart';

class chat extends StatefulWidget {
  const chat({Key? key}) : super(key: key);

  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 200,
        child: Text(
          'Chat',
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
