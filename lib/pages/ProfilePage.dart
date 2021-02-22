import 'package:flutter/material.dart';
import 'package:mask_up_ph/pages/Analytics.dart';
import 'package:mask_up_ph/pages/Home.dart';
import 'package:mask_up_ph/pages/Hospital.dart';
import 'package:mask_up_ph/pages/News.dart';

/// This is the main application widget.
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _index = 0;

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
        child = Home();
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
      body: Center(
        child: SizedBox.expand(child: child),
      ),
      bottomNavigationBar: _navigationBar(),
    );
  }
}
