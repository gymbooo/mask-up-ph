import 'package:flutter/material.dart';

class Hospitals extends StatefulWidget {
  @override
  _HospitalsState createState() => _HospitalsState();
}

class _HospitalsState extends State<Hospitals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text('HOSPITAL PAGE'),
      ),
    );
  }
}
