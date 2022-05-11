import 'package:flutter/material.dart';
import 'package:projet_fin_etud_l3_flutter/agence/Accueil.dart';
import 'package:projet_fin_etud_l3_flutter/agence/chat.dart';
import 'package:projet_fin_etud_l3_flutter/agence/offerinfo.dart';
import 'package:projet_fin_etud_l3_flutter/agence/postadd.dart';
import 'package:projet_fin_etud_l3_flutter/agence/profileagence.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home_agence extends StatefulWidget {
  const home_agence({Key? key}) : super(key: key);

  @override
  State<home_agence> createState() => _homeState();
}

class _homeState extends State<home_agence>  {
  

  @override
  var currentIndex = 0;

  PageController _pageController = PageController(initialPage: 0);
  Widget build(BuildContext context) {
    final ScreenWidth = MediaQuery.of(context).size.width;
    final ScreenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: [
          accueil(),
          postadd(),
          chat(),
          profileagence(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
          index: currentIndex,
          color: Color.fromRGBO(84, 140, 129, 1),
          height: ScreenHeight * 0.065,
          buttonBackgroundColor: Color.fromRGBO(6, 64, 64, 1),
          backgroundColor: Colors.transparent,
          onTap: (index) {
            _pageController.animateToPage(index,
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
