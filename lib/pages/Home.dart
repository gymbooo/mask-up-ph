import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutterauth0/widgets/custom_appbar_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
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
    });

    return "Success";
  }

  final formatter = new NumberFormat("###,###,###");

  @override
  Widget build(BuildContext context) {
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
                  CustomAppBarWidget(),
                  Padding(
                    padding: EdgeInsets.only(left: 25, top: 30),
                    child: Text(
                      'Good morning, user!',
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
                    child: Text('Last updated: ${covidData.lastUpdatedAtApify}',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFFEEEEEE).withOpacity(0.5))),
                  ),
                  buildGridView(),
                  buildListView()
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
      shrinkWrap: true,
      children: <Widget>[
        Card(
            color: const Color(0xFF32A373),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: Image.asset(
                    'lib/assets/images/symptoms.png',
                    height: 70,
                    width: 70,
                  ),
                ),
                Text(
                  'What are the symptoms\nof Coronavirus?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      color: const Color(0xFFEEEEEE),
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.chevron_right,
                  color: const Color(0xFFEEEEEE),
                )
              ],
            ),
            margin: EdgeInsets.only(right: 25.0, left: 25.0, bottom: 15.0)),
        Card(
            color: const Color(0xFF32A373),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: Image.asset(
                    'lib/assets/images/safety.png',
                    height: 70,
                    width: 70,
                  ),
                ),
                Text(
                  'How do I prevent\ninfections?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      color: const Color(0xFFEEEEEE),
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.chevron_right,
                  color: const Color(0xFFEEEEEE),
                )
              ],
            ),
            margin: EdgeInsets.only(right: 25.0, left: 25.0, bottom: 15.0)),
        Card(
            color: const Color(0xFF32A373),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: Image.asset(
                    'lib/assets/images/share.png',
                    height: 70,
                    width: 70,
                  ),
                ),
                Text(
                  'Get support from\nthe community',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      color: const Color(0xFFEEEEEE),
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.chevron_right,
                  color: const Color(0xFFEEEEEE),
                )
              ],
            ),
            margin: EdgeInsets.only(right: 25.0, left: 25.0, bottom: 15.0)),
      ],
    );
  }
}
