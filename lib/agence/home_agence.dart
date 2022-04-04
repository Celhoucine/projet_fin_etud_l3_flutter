import 'package:flutter/material.dart';
import 'package:projet_fin_etud_l3_flutter/agence/Accueil.dart';
import 'package:projet_fin_etud_l3_flutter/agence/addpost.dart';
import 'package:projet_fin_etud_l3_flutter/agence/chat.dart';
import 'package:projet_fin_etud_l3_flutter/agence/offerinfo.dart';
import 'package:projet_fin_etud_l3_flutter/agence/profileagence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class home_agence extends StatefulWidget {
  const home_agence({Key? key}) : super(key: key);

  @override
  State<home_agence> createState() => _homeState();
}

class _homeState extends State<home_agence> {
  @override
  // void initState() {
  //   accueilState().getOffer();
  //   super.initState();
  // }

  @override
  var currentIndex = 0;

  PageController _pageController = PageController(initialPage: 0);
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: PageView(

        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: [
          accueil(),
          addpost(),
          chat(),
          profileagence(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color.fromRGBO(6, 64, 64, 1),
          unselectedItemColor: Color.fromRGBO(84, 140, 129, 1),
          backgroundColor: Colors.white,
          onTap: (index) {
            _pageController.animateToPage(index,
                duration: Duration(microseconds: 500), curve: Curves.ease);
          },
          items: [
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.home,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.add_circle_outline_sharp),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.message,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(Icons.person),
            ),
          ]),
    ));
  }
}
