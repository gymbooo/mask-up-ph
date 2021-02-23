import 'package:flutter/material.dart';
import 'package:mask_up_ph/widgets/consts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mask_up_ph/pages/MainDrawer.dart';
import 'package:expansion_card/expansion_card.dart';

class Home extends StatefulWidget {
  final String givenName;

  Home(this.givenName);

  @override
  _HomeState createState() => _HomeState(givenName);
}

class COVIDData {
  int infected;
  int tested;
  int recovered;
  int deceased;
  int activeCases;
  int unique;
  String country;
  String historyData;
  String sourceUrl;
  String lastUpdatedAtApify;

  COVIDData(
      this.infected,
      this.tested,
      this.recovered,
      this.deceased,
      this.activeCases,
      this.unique,
      this.country,
      this.historyData,
      this.sourceUrl,
      this.lastUpdatedAtApify);
}

class _HomeState extends State<Home> {
  final String givenName;

  _HomeState(this.givenName);

  final String url =
      'https://api.apify.com/v2/key-value-stores/lFItbkoNDXKeSWBBA/records/LATEST?disableRedirect=true';
  COVIDData covidData;
  int infected;
  int tested;
  int recovered;
  int deceased;
  int activeCases;
  int unique;
  String country;
  String historyData;
  String sourceUrl;
  String lastUpdatedAtApify;
  DateTime date;
  String formattedDate;

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      infected = convertDataToJson['infected'];
      tested = convertDataToJson['tested'];
      recovered = convertDataToJson['recovered'];
      deceased = convertDataToJson['deceased'];
      activeCases = convertDataToJson['activeCases'];
      unique = convertDataToJson['unique'];
      country = convertDataToJson['country'];
      historyData = convertDataToJson['historyData'];
      sourceUrl = convertDataToJson['sourceUrl'];
      lastUpdatedAtApify = convertDataToJson['lastUpdatedAtApify'];
      covidData = COVIDData(infected, tested, recovered, deceased, activeCases,
          unique, country, historyData, sourceUrl, lastUpdatedAtApify);
      // print(covidData);
      date = DateTime.parse(lastUpdatedAtApify);
      formattedDate = DateFormat.yMMMMd('en_US').add_jm().format(date);
    });

    return "Success";
  }

  final formatter = new NumberFormat("###,###,###");
  String greeting;

 // TimeOfDay now = TimeOfDay.now();
  final int time = TimeOfDay.now().hour;
  final int timeMin = TimeOfDay.now().minute;


  @override
  Widget build(BuildContext context) {
    if(time < 12){
      greeting = 'Good morning, ';
    }
    else if(time == 12 && timeMin == 0){
      greeting = 'Good noon, ';
    }
    else if(time >= 12 && time <= 17 && timeMin > 0){
      greeting = 'Good afternoon, ';
    }
    else{
      greeting = 'Good evening, ';
    }
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/images/background.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: FutureBuilder<String>(
            future: getJsonData(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return ListView(children: <Widget>[
                  //CustomAppBarWidget(),
                  Padding(
                    padding: EdgeInsets.only(left: 25, top: 25),
                    child: Text(
                      '$greeting$givenName!',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFEEEEEE)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25, top: 25),
                    child: Text('Cases in the ${covidData.country}',
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFFEEEEEE))),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 27, top: 1),
                    child: Text('Last updated: $formattedDate',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFFEEEEEE).withOpacity(0.5))),
                  ),
                  Expanded(child: buildGridView()),
                  Expanded(child: buildListView())
                ]);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  //-----------gridview

  GridView buildGridView() {
    return GridView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 3 / 2),
      children: <Widget>[
        Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            color: const Color(0xFF24006D),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 30,
                        color: const Color(0xFFEEEEEE),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatter.format(activeCases),
                    style: TextStyle(
                        fontSize: 30,
                        color: const Color(0xFFFFE45B),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.only(left: 25, top: 25, bottom: 15, right: 7)),
        Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            color: const Color(0xFF24006D),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deceased',
                    style: TextStyle(
                        fontSize: 30,
                        color: const Color(0xFFEEEEEE),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatter.format(deceased),
                    style: TextStyle(
                        fontSize: 30,
                        color: const Color(0xFFFF5454),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.only(right: 25, top: 25, left: 7, bottom: 15)),
        Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            color: const Color(0xFF24006D),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recovered',
                    style: TextStyle(
                        fontSize: 30,
                        color: const Color(0xFFEEEEEE),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatter.format(recovered),
                    style: TextStyle(
                        fontSize: 30,
                        color: const Color(0xFF5BC7FF),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.only(left: 25, bottom: 40, right: 7)),
        Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            color: const Color(0xFF24006D),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unique',
                    style: TextStyle(
                        fontSize: 30,
                        color: const Color(0xFFEEEEEE),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatter.format(unique),
                    style: TextStyle(
                        fontSize: 30,
                        color: const Color(0xFFEEEEEE),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.only(right: 25, left: 7, bottom: 40)),
      ],
    );
  }

  //-----------listview

  ListView buildListView() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
         ExpansionCard(
            backgroundColor: const Color(0xFF32A373),
            borderRadius: 10,
            margin: EdgeInsets.only(right: 15.0, left: 15.0, bottom: 15.0),
            title: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('lib/assets/images/symptoms.png', width: 70, height: 70),
                  Text(
                    'What are the symptoms\nof Coronavirus?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22,
                        color: const Color(0xFFEEEEEE),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 7),
               // child: Text("Content goes over here!", style: TextStyle(fontSize: 20, color: Colors.white),),
                  height: 130,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 16),
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      _buildSymptomItem("lib/assets/images/1.png", "Fever"),
                      _buildSymptomItem("lib/assets/images/2.png", "Dry Cough"),
                      _buildSymptomItem("lib/assets/images/3.png", "Headache"),
                      _buildSymptomItem("lib/assets/images/4.png", "Breathless"),
                    ],
                  ),
                ),
            ],
          ),

        ExpansionCard(
          backgroundColor: const Color(0xFF32A373),
          borderRadius: 10,
          margin: EdgeInsets.only(right: 15.0, left: 15.0, bottom: 15.0),
          title: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('lib/assets/images/safety.png', width: 70, height: 70),
                Text(
                  'How do I prevent\ninfections?',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 22,
                      color: const Color(0xFFEEEEEE),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 7),
             // child: Text("Content goes over here!", style: TextStyle(fontSize: 20, color: Colors.white),),
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 16),
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  _buildSymptomItem("lib/assets/images/protection-1.png", "Avoid close\ncontact"),
                  _buildSymptomItem("lib/assets/images/protection-2.png", "Stay at\nhome"),
                  _buildSymptomItem("lib/assets/images/protection-3.png", "Wash your\nhands"),
                  _buildSymptomItem("lib/assets/images/protection-4.png", "Cover sneeze"),
                  _buildSymptomItem("lib/assets/images/protection-5.png", "Wear your\nfacemask"),
                  _buildSymptomItem("lib/assets/images/protection-6.png", "Clean objects"),
                ],
              ),
            )
          ],
        ),

        ExpansionCard(
          backgroundColor: const Color(0xFF32A373),
          borderRadius: 10,
          margin: EdgeInsets.only(right: 15.0, left: 15.0, bottom: 15.0),
          title: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('lib/assets/images/share.png', width: 70, height: 70),
                Text(
                  'Give support to\nthe community',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      color: const Color(0xFFEEEEEE),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 7),
             // child: Text("Content goes over here!", style: TextStyle(fontSize: 20, color: Colors.white),),
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 16),
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  _buildSymptomItem("lib/assets/images/icon.png", "Support local\ncharities"),
                  _buildSymptomItem("lib/assets/images/12.png", "Support local\nbusinesses"),
                  _buildSymptomItem("lib/assets/images/11.png", "Be a great\nfriend"),
                  _buildSymptomItem("lib/assets/images/13.png", "Have healthy\nconversation"),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildSymptomItem(String path, String text) {
    return Column(
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            gradient: LinearGradient(
              colors: [
                AppColors.backgroundColor,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(1, 1),
                spreadRadius: 1,
                blurRadius: 3,
              )
            ],
          ),
          padding: EdgeInsets.only(top: 15),
          child: Image.asset(path),
          margin: EdgeInsets.only(right: 20),
        ),
        SizedBox(height: 7),
        Text(
          text,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
