import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_up_ph/pages/Analytics.dart';
import 'package:mask_up_ph/pages/Home.dart';
import 'package:mask_up_ph/pages/Hospital.dart';
import 'package:mask_up_ph/pages/News.dart';
import 'package:mask_up_ph/pages/MainDrawer.dart';
import 'package:mask_up_ph/widgets/consts.dart';
import 'package:mask_up_ph/pages/QR.dart';

class ProfilePage extends StatefulWidget {
  final String name;
  final String givenName;
  final String email;
  final String picture;
  final logoutAction;

  ProfilePage(
      this.name, this.givenName, this.email, this.picture, this.logoutAction);

  @override
  _ProfilePageState createState() =>
      _ProfilePageState(name, givenName, email, picture, logoutAction);
}

class _ProfilePageState extends State<ProfilePage> {
  final String name;
  final String givenName;
  final String email;
  final String picture;
  final logoutAction;

  _ProfilePageState(
      this.name, this.givenName, this.email, this.picture, this.logoutAction);

  int _selectedIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainAppBarColor,
        title: Text('Mask Up PH',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  print('qr icon tapped');
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => QR()));
                  // QR();
                },
                child: Icon(
                  Icons.qr_code,
                  size: 26.0,
                ),
              )),
        ],
      ),
      drawer: MainDrawer(name, email, picture, logoutAction),
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(
        child: PageView(
          physics: _selectedIndex == 3
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            print('page index $index');
            setState(() => _selectedIndex = index);
          },
          children: <Widget>[
            Home(givenName),
            Analytics(),
            News(),
            Hospital(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0xFF400060),
        unselectedItemColor: const Color(0xFFEEEEEE),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.coronavirus_outlined),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Hospitals',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: new Duration(milliseconds: 800),
          curve: Curves.easeInOutExpo);
    });
  }
}
