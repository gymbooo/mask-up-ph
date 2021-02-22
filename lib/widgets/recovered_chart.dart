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

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(
      Map<String, int> map) {
    final data = [
      new TimeSeriesSales(new DateTime(2020, 4), 1043),
      new TimeSeriesSales(new DateTime(2020, 5), 3909),
      new TimeSeriesSales(new DateTime(2020, 6), 10233),
      new TimeSeriesSales(new DateTime(2020, 7), 65178),
      new TimeSeriesSales(new DateTime(2020, 8), 157403),
      new TimeSeriesSales(new DateTime(2020, 9), 5381),
      new TimeSeriesSales(new DateTime(2020, 10), 328602),
      new TimeSeriesSales(new DateTime(2020, 11), 398658),
      new TimeSeriesSales(new DateTime(2020, 12), 439796),
      new TimeSeriesSales(new DateTime(2021, 1), 487551),
      new TimeSeriesSales(new DateTime(2021, 2), 522843),
    ];
    // map.forEach((k, v) => data.add(
    //     new TimeSeriesSales(new DateFormat('M/yyyy').parse(k), v.toInt())));

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Recovered Cases',
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
        mapData[formattedDate] = covidDataGraph.getRecovered;
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
                    "COVID 19 Total Recovered Cases",
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
