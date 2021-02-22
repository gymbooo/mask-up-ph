import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';

class ConfirmedChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConfirmedChartState();
}

class ConfirmedData {
  final DateTime month;
  final int total;

  ConfirmedData(this.month, this.total);
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

class ConfirmedChartState extends State<ConfirmedChart> {
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

  static List<charts.Series<ConfirmedData, DateTime>> _createData(
      Map<String, int> map) {
    final data = [
      new ConfirmedData(new DateTime(2020, 4), 8488),
    ];
    map.forEach((k, v) => data
        .add(new ConfirmedData(new DateFormat('M/yyyy').parse(k), v.toInt())));

    return [
      new charts.Series<ConfirmedData, DateTime>(
        id: 'Confirmed Cases',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ConfirmedData confirmed, _) => confirmed.month,
        measureFn: (ConfirmedData confirmed, _) => confirmed.total,
        data: data,
      )
    ];
  }

  @override
  void initState() {
    super.initState();
    // timer = new Timer.periodic(new Duration(seconds: 2), (t) => getGraphData());
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
        mapData[formattedDate] = covidDataGraph.getConfirmed;
      }
      // List<charts.Series<TimeSeriesSales, DateTime>> newList = [];
      // mapData.forEach((k,v) => newList.add(createSeries(k,v)));
      print('confirmed $mapData');
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
                  "COVID 19 Total Confirmed Cases",
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
