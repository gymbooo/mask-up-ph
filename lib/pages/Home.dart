import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_up_ph/widgets/consts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
      {this.infected,
      this.tested,
      this.recovered,
      this.deceased,
      this.activeCases,
      this.unique,
      this.country,
      this.historyData,
      this.sourceUrl,
      this.lastUpdatedAtApify});

  factory COVIDData.fromJson(Map<String, dynamic> json) {
    return COVIDData(
      infected: json['infected'],
      tested: json['tested'],
      recovered: json['recovered'],
      deceased: json['deceased'],
      activeCases: json['activeCases'],
      unique: json['unique'],
      country: json['country'],
      historyData: json['historyData'],
      sourceUrl: json['sourceUrl'],
      lastUpdatedAtApify: json['lastUpdatedAtApify'],
    );
  }
}

Future<COVIDData> fetchCOVIDData() async {
  final response = await http.get(
      'https://api.apify.com/v2/key-value-stores/lFItbkoNDXKeSWBBA/records/LATEST?disableRedirect=true');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return COVIDData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load COVID data');
  }
}

class _HomeState extends State<Home> {
  final String givenName;

  _HomeState(this.givenName);

  Future<COVIDData> futureCOVIDData;
  DateTime date;
  String formattedDate;

  @override
  void initState() {
    super.initState();
    futureCOVIDData = fetchCOVIDData();
  }

  final formatter = new NumberFormat("###,###,###");
  String greeting;

  // TimeOfDay now = TimeOfDay.now();
  final int time = TimeOfDay.now().hour;
  final int timeMin = TimeOfDay.now().minute;

  @override
  Widget build(BuildContext context) {
    if (time < 12) {
      greeting = 'Good morning, ';
    } else if (time == 12 && timeMin == 0) {
      greeting = 'Good noon, ';
    } else if (time >= 12 && time <= 17 && timeMin > 0) {
      greeting = 'Good afternoon, ';
    } else {
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
          child: FutureBuilder<COVIDData>(
            future: futureCOVIDData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildListView(
                    activeCases: snapshot.data.activeCases,
                    deceased: snapshot.data.deceased,
                    recovered: snapshot.data.recovered,
                    unique: snapshot.data.unique,
                    country: snapshot.data.country,
                    lastUpdatedAtApify: snapshot.data.lastUpdatedAtApify);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  RefreshIndicator buildListView(
      {int activeCases,
      int deceased,
      int recovered,
      int unique,
      String country,
      String lastUpdatedAtApify}) {
    date = DateTime.parse(lastUpdatedAtApify);
    formattedDate = DateFormat.yMMMMd('en_US').add_jm().format(date);
    return RefreshIndicator(
      child: ListView(children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 25, top: 25),
          child: Text(
            '$greeting$givenName!',
            style: GoogleFonts.montserrat(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFEEEEEE)),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 25, top: 25),
          child: Text('Cases in the $country',
              style: GoogleFonts.montserrat(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFFEEEEEE))),
        ),
        Container(
          padding: EdgeInsets.only(left: 27, top: 1),
          child: Text('Last updated: $formattedDate',
              style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFFEEEEEE).withOpacity(0.5))),
        ),
        Expanded(
            child: buildGridView(
                activeCases: activeCases,
                deceased: deceased,
                recovered: recovered,
                unique: unique)),
        Expanded(child: buildSymptomsListView())
      ]),
      onRefresh: fetchCOVIDData,
    );
  }

  //-----------gridview

  GridView buildGridView({
    int activeCases,
    int deceased,
    int recovered,
    int unique,
  }) {
    return GridView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 3 / 2),
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, top: 25),
          color: Colors.transparent,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            color: const Color(0xFF24006D),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(
                        fontSize: 27,
                        color: const Color(0xFFEEEEEE),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    formatter.format(activeCases),
                    style: GoogleFonts.montserrat(
                        fontSize: 30,
                        color: const Color(0xFFFFE45B),
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20, top: 25),
          color: Colors.transparent,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            color: const Color(0xFF24006D),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deceased',
                    style: GoogleFonts.montserrat(
                        fontSize: 27,
                        color: const Color(0xFFEEEEEE),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    formatter.format(deceased),
                    style: GoogleFonts.montserrat(
                        fontSize: 30,
                        color: const Color(0xFFFF5454),
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, bottom: 25),
          color: Colors.transparent,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            color: const Color(0xFF24006D),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recovered',
                    style: GoogleFonts.montserrat(
                        fontSize: 27,
                        color: const Color(0xFFEEEEEE),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    formatter.format(recovered),
                    style: GoogleFonts.montserrat(
                        fontSize: 30,
                        color: const Color(0xFF5BC7FF),
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 20, bottom: 25),
          color: Colors.transparent,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            color: const Color(0xFF24006D),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unique',
                    style: GoogleFonts.montserrat(
                        fontSize: 27,
                        color: const Color(0xFFEEEEEE),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    formatter.format(unique),
                    style: GoogleFonts.montserrat(
                        fontSize: 30,
                        color: const Color(0xFFEEEEEE),
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  //-----------listview

  ListView buildSymptomsListView() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ExpansionCard(
          backgroundColor: const Color(0xFF32A373),
          borderRadius: 10,
          margin: EdgeInsets.only(right: 15.0, left: 15.0, bottom: 15.0),
          title: Container(
            child: ListTile(
              leading: Image.asset('lib/assets/images/symptoms.png',
                  width: 60, height: 60),
              title: Text(
                'Symptoms of Coronavirus',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: const Color(0xFFEEEEEE),
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 7),
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 16),
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  _buildSymptomItem("lib/assets/images/1.png", "Fever"),
                  _buildSymptomItem("lib/assets/images/2.png", "Dry Cough"),
                  _buildSymptomItem("lib/assets/images/3.png", "Headache"),
                  _buildSymptomItem(
                      "lib/assets/images/4.png", "Breathlessness"),
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
            child: ListTile(
              leading: Image.asset('lib/assets/images/safety.png',
                  width: 60, height: 60),
              title: Text(
                'How do I prevent infections?',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: const Color(0xFFEEEEEE),
                    fontWeight: FontWeight.w500),
              ),
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
                  _buildSymptomItem("lib/assets/images/protection-1.png",
                      "Avoid close\ncontact"),
                  _buildSymptomItem(
                      "lib/assets/images/protection-2.png", "Stay at\nhome"),
                  _buildSymptomItem(
                      "lib/assets/images/protection-3.png", "Wash your\nhands"),
                  _buildSymptomItem("lib/assets/images/protection-4.png",
                      "Cover your face\nwhen sneezing"),
                  _buildSymptomItem("lib/assets/images/protection-5.png",
                      "Wear your\nfacemask"),
                  _buildSymptomItem("lib/assets/images/protection-6.png",
                      "Clean and\ndisinfect objects"),
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
            child: ListTile(
              leading: Image.asset('lib/assets/images/share.png',
                  width: 60, height: 60),
              title: Text(
                'Give support to the community',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: const Color(0xFFEEEEEE),
                    fontWeight: FontWeight.w500),
              ),
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
                  _buildSymptomItem(
                      "lib/assets/images/icon.png", "Support local\ncharities"),
                  _buildSymptomItem(
                      "lib/assets/images/12.png", "Support local\nbusinesses"),
                  _buildSymptomItem(
                      "lib/assets/images/11.png", "Be a great\nfriend"),
                  _buildSymptomItem("lib/assets/images/13.png",
                      "Have healthy\nconversations"),
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
        Padding(
          padding: EdgeInsets.only(top: 7, right: 20),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
