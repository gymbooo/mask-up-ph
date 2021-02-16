import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        )),
        child: buildListView(),
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
              Padding(
                padding: EdgeInsets.only(left: 25, top: 30),
                child: Text(
                  'Good morning, user!',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, top: 25),
                child: Text('Cases in the ${covidData.country}',
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w300,
                        color: Colors.white)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 27, top: 1),
                child: Text('Last updated \$dateTime.now()',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.white.withOpacity(0.5))),
              ),
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
