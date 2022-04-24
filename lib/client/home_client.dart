import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:projet_fin_etud_l3_flutter/client/accueilclient.dart';
import 'package:projet_fin_etud_l3_flutter/client/chatclient.dart';
import 'package:projet_fin_etud_l3_flutter/client/favorite.dart';
import 'package:projet_fin_etud_l3_flutter/client/profileclient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home_client extends StatefulWidget {
  const home_client({Key? key}) : super(key: key);

  @override
  State<home_client> createState() => _homeState();
}

class _homeState extends State<home_client> {
  @override
  var currentIndex = 0;
PageController _pageClientController = PageController(initialPage: 0);
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageClientController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: [
          accueilclient(),
          favorite(),
          chatclient(),
          profileclient(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
          index: currentIndex,
          color: Color.fromRGBO(84, 140, 129, 1),
          height: ScreenHeight * 0.065,
          buttonBackgroundColor: Color.fromRGBO(6, 64, 64, 1),
          backgroundColor: Colors.transparent,
          onTap: (index) {
          
              _pageClientController.animateToPage(index,
                  duration: Duration(microseconds: 400), curve: Curves.ease);
            
          },
          items: [
            Icon(
              Icons.home,
              color: Colors.white,
            ),
            Icon(
              Icons.add_circle_outline_sharp,
              color: Colors.white,
            ),
            Icon(
              Icons.message,
              color: Colors.white,
            ),
            Icon(
              Icons.person,
              color: Colors.white,
            ),
          ]),
    ));
  }
}
