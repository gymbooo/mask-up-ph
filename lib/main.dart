import 'package:flutter/material.dart';
import 'package:mask_up_ph/pages/Analytics.dart';
import 'package:mask_up_ph/pages/Hospital.dart';
import 'package:mask_up_ph/pages/News.dart';


void main() => runApp(MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _index = 0;

  // int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  // TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // static const List<Widget> _pages = <Widget>[
  //   Text(
  //     'Index 0: Analytics',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 1: News',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 2: Hospitals',
  //     style: optionStyle,
  //   ),
  // ];
  //
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  BottomNavigationBar _navigationBar() {
    return BottomNavigationBar(
      currentIndex: _index,
      onTap: (int index) => setState(() => _index = index),
      items: const <BottomNavigationBarItem>[
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
        child = Analytics();
        break;
      case 1:
        child = News();
        break;
      case 2:
        child = Hospitals();
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: SizedBox.expand(child: child),
      ),
      bottomNavigationBar: _navigationBar(),
    );
  }
}
