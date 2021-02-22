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

/// Sample ordinal data type.
// class OrdinalSales {
//   final String year;
//   final int sales;
//
//   OrdinalSales(this.year, this.sales);
// }

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
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

  // Defining the data
  // mapData.forEach((k,v) => dataChart.add(new ConfirmedData(new DateTime(k), v)));
  // final dataChart = [
  //   new ConfirmedData(0, 1500000),
  //   new ConfirmedData(1, 1735000),
  //   new ConfirmedData(2, 1678000),
  //   new ConfirmedData(3, 1890000),
  //   new ConfirmedData(4, 1907000),
  //   new ConfirmedData(5, 2300000),
  //   new ConfirmedData(6, 2360000),
  //   new ConfirmedData(7, 1980000),
  //   new ConfirmedData(8, 2654000),
  //   new ConfirmedData(9, 2789070),
  //   new ConfirmedData(10, 3020000),
  //   new ConfirmedData(11, 3245900),
  //   new ConfirmedData(12, 4098500),
  //   new ConfirmedData(13, 4500000),
  //   new ConfirmedData(14, 4456500),
  //   new ConfirmedData(15, 3900500),
  //   new ConfirmedData(16, 5123400),
  //   new ConfirmedData(17, 5589000),
  //   new ConfirmedData(18, 5940000),
  //   new ConfirmedData(19, 6367000),
  // ];
  //
  // _getSeriesData() {
  //   List<charts.Series<ConfirmedData, int>> series = [
  //     charts.Series(
  //         id: "Sales",
  //         data: dataChart,
  //         domainFn: (ConfirmedData series, _) => series.month,
  //         measureFn: (ConfirmedData series, _) => series.confirmed,
  //         colorFn: (ConfirmedData series, _) =>
  //             charts.MaterialPalette.blue.shadeDefault)
  //   ];
  //   return series;
  // }

  // /// Create series list with multiple series
  // static List<charts.Series<OrdinalSales, String>> _createSampleData() {
  //   final desktopSalesData = [
  //     new OrdinalSales('2014', 5),
  //     new OrdinalSales('2015', 25),
  //     new OrdinalSales('2016', 100),
  //     new OrdinalSales('2017', 75),
  //   ];
  //
  //   final tabletSalesData = [
  //     new OrdinalSales('2014', 25),
  //     new OrdinalSales('2015', 50),
  //     new OrdinalSales('2016', 10),
  //     new OrdinalSales('2017', 20),
  //   ];
  //
  //   final mobileSalesData = [
  //     new OrdinalSales('2014', 10),
  //     new OrdinalSales('2015', 15),
  //     new OrdinalSales('2016', 50),
  //     new OrdinalSales('2017', 45),
  //   ];
  //
  //   final otherSalesData = [
  //     new OrdinalSales('2014', 20),
  //     new OrdinalSales('2015', 35),
  //     new OrdinalSales('2016', 15),
  //     new OrdinalSales('2017', 10),
  //   ];
  //
  //   return [
  //     new charts.Series<OrdinalSales, String>(
  //       id: 'Desktop',
  //       domainFn: (OrdinalSales sales, _) => sales.year,
  //       measureFn: (OrdinalSales sales, _) => sales.sales,
  //       data: desktopSalesData,
  //     ),
  //     new charts.Series<OrdinalSales, String>(
  //       id: 'Tablet',
  //       domainFn: (OrdinalSales sales, _) => sales.year,
  //       measureFn: (OrdinalSales sales, _) => sales.sales,
  //       data: tabletSalesData,
  //     ),
  //     new charts.Series<OrdinalSales, String>(
  //       id: 'Mobile',
  //       domainFn: (OrdinalSales sales, _) => sales.year,
  //       measureFn: (OrdinalSales sales, _) => sales.sales,
  //       data: mobileSalesData,
  //     ),
  //     new charts.Series<OrdinalSales, String>(
  //       id: 'Other',
  //       domainFn: (OrdinalSales sales, _) => sales.year,
  //       measureFn: (OrdinalSales sales, _) => sales.sales,
  //       data: otherSalesData,
  //     ),
  //   ];
  // }

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(
      Map<String, int> map) {
    final data = [
      new TimeSeriesSales(new DateTime(2020, 4), 8488),
      new TimeSeriesSales(new DateTime(2020, 5), 18086),
      new TimeSeriesSales(new DateTime(2020, 6), 37514),
      new TimeSeriesSales(new DateTime(2020, 7), 93354),
      new TimeSeriesSales(new DateTime(2020, 8), 217396),
      new TimeSeriesSales(new DateTime(2020, 9), 307288),
      new TimeSeriesSales(new DateTime(2020, 10), 373144),
      new TimeSeriesSales(new DateTime(2020, 11), 431630),
      new TimeSeriesSales(new DateTime(2020, 12), 474064),
      new TimeSeriesSales(new DateTime(2021, 1), 525618),
      new TimeSeriesSales(new DateTime(2021, 2), 561169),
    ];
    // map.forEach((k, v) => data.add(
    //     new TimeSeriesSales(new DateFormat('M/yyyy').parse(k), v.toInt())));

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Confirmed Cases',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  // charts.Series<TimeSeriesSales, DateTime> createSeries(String id, int i) {
  //   return charts.Series<TimeSeriesSales, DateTime>(
  //     id: id,
  //     domainFn: (TimeSeriesSales series, _) => series.time,
  //     measureFn: (TimeSeriesSales series, _) => series.sales,
  //     // data is a List<LiveWerkzeuge> - extract the information from data
  //     // could use i as index - there isn't enough information in the question
  //     // map from 'data' to the series
  //     // this is a guess
  //     data: [
  //     ],
  //   );
  // }

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
        mapData[formattedDate] = covidDataGraph.getConfirmed;
      }
      // List<charts.Series<TimeSeriesSales, DateTime>> newList = [];
      // mapData.forEach((k,v) => newList.add(createSeries(k,v)));
      print('line mapdata $mapData');
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        height: 550,
        padding: EdgeInsets.all(10),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  "COVID 19 Confirmed Cases",
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
    ));
  }
}
