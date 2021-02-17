import 'package:flutter/material.dart';
import 'package:mask_up_ph/pages/Analytics.dart';
import 'package:mask_up_ph/pages/Home.dart';
import 'package:mask_up_ph/pages/Hospital.dart';
import 'package:mask_up_ph/pages/News.dart';


void main() => runApp(MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Mask Up PH';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _index = 0;

  BottomNavigationBar _navigationBar() {
    return BottomNavigationBar(
      type : BottomNavigationBarType.fixed,
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
        child = Hospitals();
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
