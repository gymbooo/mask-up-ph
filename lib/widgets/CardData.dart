import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardData extends StatelessWidget {
  String label;
  String data;

  CardData(this.label,this.data);

  @override
  Widget build(BuildContext context) {
    return new Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: new Container(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(label),
              new Text(data),
            ]),
      ),
    );
  }
}
