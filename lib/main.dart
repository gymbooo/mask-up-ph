import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(new MaterialApp(
  home: new HomePage(),
));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
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

class HomePageState extends State<HomePage> {
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
      covidData = COVIDData(
          infected, tested, recovered, deceased, activeCases, unique, country);
      print(covidData);
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Retrieve JSON via HTTP GET"),
      ),
      body: new ListView.builder(
        itemCount: covidData == null ? 0 : 1,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
            child: new Center(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Card(
                      child: new Container(
                        child: new Text(covidData.country),
                        padding: const EdgeInsets.all(20.0),
                      ),
                    ),
                    new Card(
                      child: new Container(
                        child: new Text('Infected: ${covidData.infected}'),
                        padding: const EdgeInsets.all(20.0),
                      ),
                    ),
                    new Card(
                      child: new Container(
                        child: new Text('Tested: ${covidData.tested}'),
                        padding: const EdgeInsets.all(20.0),
                      ),
                    ),
                    new Card(
                      child: new Container(
                        child: new Text('Recovered: ${covidData.recovered}'),
                        padding: const EdgeInsets.all(20.0),
                      ),
                    ),
                    new Card(
                      child: new Container(
                        child: new Text('Deceased: ${covidData.deceased}'),
                        padding: const EdgeInsets.all(20.0),
                      ),
                    ),
                    new Card(
                      child: new Container(
                        child: new Text('Active Cases: ${covidData.activeCases}'),
                        padding: const EdgeInsets.all(20.0),
                      ),
                    ),
                    new Card(
                      child: new Container(
                        child: new Text('Unique: ${covidData.unique}'.toString()),
                        padding: const EdgeInsets.all(20.0),
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
