import 'package:flutter/material.dart';
import 'package:flutterauth0/widgets/custom_appbar_widget.dart';
import 'package:flutterauth0/widgets/flutter_icons.dart';
import 'package:flutterauth0/widgets/chart_widget.dart';
import 'package:flutterauth0/widgets/consts.dart';
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
      backgroundColor: AppColors.backgroundColor,
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

  Widget _buildGender(IconData icon, Color color, String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(1, 1),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                icon,
                size: 60,
                color: color,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    "Confirmed\nCase",
                    style: TextStyle(
                      color: Colors.black38,
                      height: 1.5,
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatistic() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(1, 1),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(24),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              child: DonutPieChart.withSampleData(),
            ),
            SizedBox(width: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildStatisticItem(
                    Colors.blueAccent, "Confirmed", "23,29,539"),
                _buildStatisticItem(
                    Colors.yellowAccent, "Recovered", "5,92,229"),
                _buildStatisticItem(Colors.redAccent, "Deaths", "1,60,717"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticItem(Color color, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Icon(
          FlutterIcons.label,
          size: 50,
          color: color,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: Colors.black38,
              ),
            ),
            SizedBox(height: 5),
            Text(value),
          ],
        ),
      ],
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
