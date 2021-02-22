import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';

class RecoveredChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RecoveredChartState();
}

class RecoveredData {
  final DateTime month;
  final int total;

  RecoveredData(this.month, this.total);
}

class COVIDGraphData {
  int confirmed;
  int recovered;
  int deceased;

  COVIDGraphData(this.confirmed, this.recovered, this.deceased);

  int get getConfirmed => confirmed;

  int get getRecovered => recovered;

  int get getDeceased => deceased;
}

class RecoveredChartState extends State<RecoveredChart> {
  final String url2 =
      "https://api.apify.com/v2/datasets/sFSef5gfYg3soj8mb/items?format=json&clean=1";
  COVIDGraphData covidDataGraph;
  int confirmedGraph;
  int recoveredGraph;
  int deceasedGraph;
  Map<String, int> mapData = Map();

  DateTime date;
  String formattedDate;

  Timer timer;
  List data;

  static List<charts.Series<RecoveredData, DateTime>> _createData(
      Map<String, int> map) {
    final data = [
      new RecoveredData(new DateTime(2020, 4), 1043),
    ];
    map.forEach((k, v) => data
        .add(new RecoveredData(new DateFormat('M/yyyy').parse(k), v.toInt())));

    return [
      new charts.Series<RecoveredData, DateTime>(
        id: 'Recovered Cases',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (RecoveredData recovered, _) => recovered.month,
        measureFn: (RecoveredData recovered, _) => recovered.total,
        data: data,
      )
    ];
  }

  @override
  void initState() {
    super.initState();
    this.getGraphData();
  }

  Future<String> getGraphData() async {
    var response = await http
        .get(Uri.encodeFull(url2), headers: {"Accept": "application/json"});
    // print(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      for (var data in convertDataToJson) {
        confirmedGraph = data['infected'];
        recoveredGraph = data['recovered'];
        deceasedGraph = data['deceased'];
        covidDataGraph =
            COVIDGraphData(confirmedGraph, recoveredGraph, deceasedGraph);
        date = DateTime.parse(data['lastUpdatedAtApify']);
        formattedDate = DateFormat.yM().format(date);
        mapData[formattedDate] = covidDataGraph.getRecovered;
      }
      print('recovered $mapData');
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 550,
        padding: EdgeInsets.all(10),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  "COVID 19 Total Recovered Cases",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: FutureBuilder<String>(
                    future: getGraphData(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        return new charts.TimeSeriesChart(
                          _createData(mapData),
                          animate: true,
                          behaviors: [new charts.SeriesLegend()],
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
