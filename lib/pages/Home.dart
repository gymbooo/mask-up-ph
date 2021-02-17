import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  COVIDData(this.infected,
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
      "https://api.apify.com/v2/key-value-stores/lFItbkoNDXKeSWBBA/records/LATEST?disableRedirect=true";
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
    // TODO: implement initState
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
      covidData = COVIDData(
          infected,
          tested,
          recovered,
          deceased,
          activeCases,
          unique,
          country,
          historyData,
          sourceUrl,
          lastUpdatedAtApify);
      print(covidData);
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: FutureBuilder<String>(
            future: getJsonData(),
            // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: <Widget>[
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
                      child: Text(
                          'Last updated: ${covidData.lastUpdatedAtApify}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFFEEEEEE).withOpacity(0.5))),
                    ),
                    GridView(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 3 / 2),
                      children: <Widget>[
                        Card(
                            color: const Color(0xFF24006D),
                            child: Column(
                              children: [
                                Text(
                                  'Active',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xFFEEEEEE),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${covidData.activeCases}',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xFFFFE45B),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(
                                left: 25, top: 25, bottom: 15, right: 7)),
                        Card(
                            color: const Color(0xFF24006D),
                            child: Column(
                              children: [
                                Text(
                                  'Deceased',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xFFEEEEEE),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${covidData.deceased}',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xFFFF5454),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(
                                right: 25, top: 25, left: 7, bottom: 15)),
                        Card(
                            color: const Color(0xFF24006D),
                            child: Column(
                              children: [
                                Text(
                                  'Recovered',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xFFEEEEEE),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${covidData.recovered}',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xFF5BC7FF),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(
                                left: 25, bottom: 40, right: 7)),
                        Card(
                            color: const Color(0xFF24006D),
                            child: Column(
                              children: [
                                Text(
                                  'Unique',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xFFEEEEEE),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${covidData.unique}',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: const Color(0xFFEEEEEE),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(
                                right: 25, left: 7, bottom: 40)),
                      ],
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Card(
                            child: Text('symptoms'),
                            margin: const EdgeInsets.all(20.0)),
                        Card(
                            child: Text('safety measures'),
                            margin: const EdgeInsets.all(20.0)),
                        Card(
                            child: Text('community'),
                            margin: const EdgeInsets.all(20.0)),
                      ],
                    )
                  ],
                );

              } else {
              return Center(child: CircularProgressIndicator());
              }
            }
        ),


      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: covidData == null ? 0 : 1,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    child: Container(
                      width: 20,
                      child: Text('Infected: ${covidData.infected}'),
                      padding: const EdgeInsets.all(20.0),
                    ),
                  ),
                  Card(
                    child: Container(
                      child: Text('Tested: ${covidData.tested}'),
                      padding: const EdgeInsets.all(20.0),
                    ),
                  ),
                  Card(
                    child: Container(
                      child: Text('Recovered: ${covidData.recovered}'),
                      padding: const EdgeInsets.all(20.0),
                    ),
                  ),
                  Card(
                    child: Container(
                      child: Text('Deceased: ${covidData.deceased}'),
                      padding: const EdgeInsets.all(20.0),
                    ),
                  ),
                  Card(
                    child: Container(
                      child: Text('Active Cases: ${covidData.activeCases}'),
                      padding: const EdgeInsets.all(20.0),
                    ),
                  ),
                  Card(
                    child: Container(
                      child: Text('Unique: ${covidData.unique}'.toString()),
                      padding: const EdgeInsets.all(20.0),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
