import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';

class DeceasedChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DeceasedChartState();
}

class DeceasedData {
  final DateTime month;
  final int total;

  DeceasedData(this.month, this.total);
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

class DeceasedChartState extends State<DeceasedChart> {
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

  static List<charts.Series<DeceasedData, DateTime>> _createData(
      Map<String, int> map) {
    final data = [
      new DeceasedData(new DateTime(2020, 4), 568),
    ];
    map.forEach((k, v) => data
        .add(new DeceasedData(new DateFormat('M/yyyy').parse(k), v.toInt())));

    return [
      new charts.Series<DeceasedData, DateTime>(
        id: 'Deceased Cases',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (DeceasedData deceased, _) => deceased.month,
        measureFn: (DeceasedData deceased, _) => deceased.total,
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
        mapData[formattedDate] = covidDataGraph.getDeceased;
      }
      print('deceased $mapData');
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
                  "COVID 19 Total Deceased Cases",
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
