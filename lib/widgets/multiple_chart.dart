import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';

class MultipleChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MultipleChartState();
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

class COVIDData {
  final DateTime month;
  final int total;

  COVIDData(this.month, this.total);
}

class MultipleChartState extends State<MultipleChart> {
  final String url2 =
      "https://api.apify.com/v2/datasets/sFSef5gfYg3soj8mb/items?format=json&clean=1";
  COVIDGraphData covidDataGraph;
  int confirmedGraph;
  int recoveredGraph;
  int deceasedGraph;
  Map<String, int> confirmedDataMap = Map();
  Map<String, int> recoveredDataMap = Map();
  Map<String, int> deceasedDataMap = Map();

  DateTime date;
  String formattedDate;

  Timer timer;
  List data;

  static List<charts.Series<COVIDData, DateTime>> _createSampleData(
      Map<String, int> map1, Map<String, int> map2, Map<String, int> map3) {
    final confirmedData = [
      new COVIDData(new DateTime(2020, 4), 8488),
    ];
    map1.forEach((k, v) => confirmedData
        .add(new COVIDData(new DateFormat('M/yyyy').parse(k), v.toInt())));

    final recoveredData = [
      new COVIDData(new DateTime(2020, 4), 1043),
    ];
    map2.forEach((k, v) => recoveredData
        .add(new COVIDData(new DateFormat('M/yyyy').parse(k), v.toInt())));

    final deceasedData = [
      new COVIDData(new DateTime(2020, 4), 568),
    ];
    map3.forEach((k, v) => deceasedData
        .add(new COVIDData(new DateFormat('M/yyyy').parse(k), v.toInt())));

    return [
      new charts.Series<COVIDData, DateTime>(
        id: 'Confirmed',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (COVIDData cases, _) => cases.month,
        measureFn: (COVIDData cases, _) => cases.total,
        data: confirmedData,
      ),
      new charts.Series<COVIDData, DateTime>(
          id: 'Recovered',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (COVIDData cases, _) => cases.month,
          measureFn: (COVIDData cases, _) => cases.total,
          data: recoveredData),
      new charts.Series<COVIDData, DateTime>(
        id: 'Deceased',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (COVIDData cases, _) => cases.month,
        measureFn: (COVIDData cases, _) => cases.total,
        data: deceasedData,
      ),
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
        confirmedDataMap[formattedDate] = covidDataGraph.getConfirmed;
        recoveredDataMap[formattedDate] = covidDataGraph.getRecovered;
        deceasedDataMap[formattedDate] = covidDataGraph.getDeceased;
      }
      print('multiple confirmed $confirmedDataMap');
      print('multiple recovered $recoveredDataMap');
      print('multiple deceased $deceasedDataMap');
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
                  "COVID 19 Cases",
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
                          _createSampleData(confirmedDataMap, recoveredDataMap,
                              deceasedDataMap),
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
