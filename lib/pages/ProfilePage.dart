import 'package:flutter/material.dart';
import 'package:mask_up_ph/pages/Analytics.dart';
import 'package:mask_up_ph/pages/Home.dart';
import 'package:mask_up_ph/pages/Hospital.dart';
import 'package:mask_up_ph/pages/News.dart';
import 'package:mask_up_ph/pages/MainDrawer.dart';
import 'package:mask_up_ph/widgets/consts.dart';

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
  int _index = 0;
  final String name;
  final String givenName;
  final String email;
  final String picture;
  final logoutAction;

  _ProfilePageState(
      this.name, this.givenName, this.email, this.picture, this.logoutAction);

  BottomNavigationBar _navigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF400060),
      unselectedItemColor: const Color(0xFFEEEEEE),
      type: BottomNavigationBarType.fixed,
      currentIndex: _index,
      onTap: (int index) => setState(() => _index = index),
      items: const <BottomNavigationBarItem>[
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
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    switch (_index) {
      case 0:
        child = Home(givenName);
        break;
      case 1:
        child = Analytics();
        break;
      case 2:
        child = News();
        break;
      case 3:
        child = Hospital();
        break;
    }
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.mainAppBarColor),
      drawer: MainDrawer(name, email, picture, logoutAction),
      backgroundColor: Colors.transparent,
      body: Center(
        child: SizedBox.expand(child: child),
      ),
      bottomNavigationBar: _navigationBar(),
    );
  }
}
