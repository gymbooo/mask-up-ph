import 'package:mask_up_ph/widgets/flutter_icons.dart';
import 'package:flutter/material.dart';
import 'package:mask_up_ph/main.dart';

class CustomAppBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(
            FlutterIcons.menu,
            color: Colors.white,
          ),
          onPressed: (){
            drawer: Drawer(

            );
          },
        ),
        Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
            image: DecorationImage(
              image: AssetImage("lib/assets/images/profile.png"),
            ),
          ),
        )
      ],
    );
    ;
  }
}
