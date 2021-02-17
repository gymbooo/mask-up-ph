import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutterauth0/widgets/CardData.dart';

class Analytics extends StatefulWidget {
  @override
  _AnalyticsState createState() => _AnalyticsState();
}

class COVIDData {
  int infected;
  int tested;
  int recovered;
  int deceased;
  int activeCases;
  int unique;
  String country;

  COVIDData(this.infected, this.tested, this.recovered, this.deceased,
      this.activeCases, this.unique, this.country);
}

class _AnalyticsState extends State<Analytics> {
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
      covidData = COVIDData(
          infected, tested, recovered, deceased, activeCases, unique, country);
      print(covidData);
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder<String>(
        future: getJsonData(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return GridView.extent(
              primary: false,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              maxCrossAxisExtent: 200.0,
              children: <Widget>[
                CardData('Active Cases', '${covidData.activeCases}'),
                CardData('Deceased', '${covidData.deceased}'),
                CardData('Recovered', '${covidData.recovered}'),
                CardData('Unique', '${covidData.unique}'),
                CardData('Tested', '${covidData.tested}'),
                CardData('Infected', '${covidData.infected}'),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )),
    );
  }
}
