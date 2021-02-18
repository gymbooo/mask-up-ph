import 'package:flutter/material.dart';
import 'package:flutterauth0/widgets/custom_appbar_widget.dart';
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

  // @override
  // Widget build(BuildContext context) {
  //   return new Scaffold(
  //     appBar: new AppBar(
  //       title: new Text("Retrieve JSON via HTTP GET"),
  //     ),
  //     body: new ListView.builder(
  //       itemCount: covidData == null ? 0 : 1,
  //       itemBuilder: (BuildContext context, int index) {
  //         return new Container(
  //           child: new Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 new Column(
  //                   children: <Widget>[
  //                     new Card(
  //                       child: new Container(
  //                         child: new Text(
  //                             'Active Cases: ${covidData.activeCases}'),
  //                         padding: const EdgeInsets.all(20.0),
  //                       ),
  //                     ),
  //                     new Card(
  //                       child: new Container(
  //                         child: new Text('Recovered: ${covidData.recovered}'),
  //                         padding: const EdgeInsets.all(20.0),
  //                       ),
  //                     ),
  //                     new Card(
  //                       child: new Container(
  //                         child: new Text('Tested: ${covidData.tested}'),
  //                         padding: const EdgeInsets.all(20.0),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 new Column(
  //                   children: <Widget>[
  //                     new Card(
  //                       child: new Container(
  //                         child: new Text('Deceased: ${covidData.deceased}'),
  //                         padding: const EdgeInsets.all(20.0),
  //                       ),
  //                     ),
  //                     new Card(
  //                       child: new Container(
  //                         child: new Text(
  //                             'Unique: ${covidData.unique}'.toString()),
  //                         padding: const EdgeInsets.all(20.0),
  //                       ),
  //                     ),
  //                     new Card(
  //                       child: new Container(
  //                         child: new Text('Infected: ${covidData.infected}'),
  //                         padding: const EdgeInsets.all(20.0),
  //                       ),
  //                     ),
  //                   ],
  //                 )
  //               ]),
  //         );
  //       },
  //     ),
  //   );
  // }

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

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Container(
//       decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/background.png'),
//             fit: BoxFit.cover,
//           )),
//       child: Column(
//         children: [
//           buildContainerHeader(),
//           buildGridView(),
//         ],
//       ),
//     ),
//   );
// }
//
// Container buildContainerHeader() {
//   return Container(
//       child: Center(
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.only(left: 25, top: 30),
//                   child: Text(
//                     'Good morning, user!',
//                     style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 25, top: 25),
//                   child: Text('Cases in the ${covidData.country}',
//                       style: TextStyle(
//                           fontSize: 23,
//                           fontWeight: FontWeight.w300,
//                           color: Colors.white)),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 27, top: 1),
//                   child: Text('Last updated \$dateTime.now()',
//                       style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w300,
//                           color: Colors.white.withOpacity(0.5))),
//                 ),
//               ]
//           )
//       )
//   );
// }
//
// GridView buildGridView() {
//   return GridView.extent(
//     primary: false,
//     padding: const EdgeInsets.all(16),
//     crossAxisSpacing: 20,
//     mainAxisSpacing: 20,
//     maxCrossAxisExtent: 200.0,
//     children: <Widget>[
//       CardData('Active Cases', '${covidData.activeCases}'),
//       CardData('Deceased', '${covidData.deceased}'),
//       CardData('Recovered', '${covidData.recovered}'),
//       CardData('Unique', '${covidData.unique}'),
//       CardData('Tested', '${covidData.tested}'),
//       CardData('Infected', '${covidData.infected}'),
//     ],
//   );
// }
}
