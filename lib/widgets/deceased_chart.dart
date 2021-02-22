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

class ConfirmedData {
  final int month;
  final int confirmed;

  ConfirmedData(this.month, this.confirmed);
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

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
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


  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(
      Map<String, int> map) {
    final data = [
      new TimeSeriesSales(new DateTime(2020, 4), 568),
      new TimeSeriesSales(new DateTime(2020, 5), 957),
      new TimeSeriesSales(new DateTime(2020, 6), 1266),
      new TimeSeriesSales(new DateTime(2020, 7), 2023),
      new TimeSeriesSales(new DateTime(2020, 8), 3520),
      new TimeSeriesSales(new DateTime(2020, 9), 5381),
      new TimeSeriesSales(new DateTime(2020, 10), 7053),
      new TimeSeriesSales(new DateTime(2020, 11), 8392),
      new TimeSeriesSales(new DateTime(2020, 12), 9244),
      new TimeSeriesSales(new DateTime(2021, 1), 10749),
      new TimeSeriesSales(new DateTime(2021, 2), 12088),
    ];
    // map.forEach((k, v) => data.add(
    //     new TimeSeriesSales(new DateFormat('M/yyyy').parse(k), v.toInt())));

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Deceased Cases',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  @override
  void initState() {
    super.initState();
    // this.getGraphData();
    timer = new Timer.periodic(new Duration(seconds: 2), (t) => getGraphData());
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
      print('line mapdata $mapData');
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
                  child: new charts.TimeSeriesChart(
                     _createSampleData(mapData),
                    animate: true,
                    behaviors: [new charts.SeriesLegend()],
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
