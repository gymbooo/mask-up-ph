import 'package:flutter/material.dart';
import 'package:flutterauth0/widgets/consts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutterauth0/pages/FAQPage.dart';
import 'package:flutterauth0/main.dart';

class MainDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Drawer(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: AppColors.appBarColor,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 30, bottom: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                              image: AssetImage("lib/assets/images/profile.png"),
                              fit: BoxFit.fill
                      ),
                      ),
                    ),
                    Text('username', style: TextStyle(fontSize: 22, color: Colors.white)),
                    Text('email@gmail.com', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.question_answer_outlined),
              title: Text('FAQs', style: TextStyle(fontSize: 19)),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => FAQPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money_outlined),
              title: Text('Donations', style: TextStyle(fontSize: 19)),
              onTap: () {
                launch('https://give2asia.org/covid-19-pandemic-response-philippines/');
              },
            ),
            ListTile(
              leading: Icon(Icons.warning_amber_outlined),
              title: Text('Myth Busters', style: TextStyle(fontSize: 19)),
              onTap: () {
                launch(
                    'https://www.who.int/emergencies/diseases/novel-coronavirus-2019/advice-for-public/myth-busters');
              },
            ),
            ListTile(
              leading: Icon(Icons.call_outlined),
              title: Text('Emergency Hotlines', style: TextStyle(fontSize: 19)),
              onTap: () {
                launch('https://www.gov.ph/hotlines');
              },
            ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout', style: TextStyle(fontSize: 19)),
                onTap: () {
                },
              ),
          ],
        )
    );
  }
}