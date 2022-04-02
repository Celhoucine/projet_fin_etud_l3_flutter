import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home_client extends StatefulWidget {
  const home_client({Key? key}) : super(key: key);

  @override
  State<home_client> createState() => _homeState();
}

class _homeState extends State<home_client> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('Welcome to client'),
      ),
    );
  }
}
