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

class COVIDData {
  final DateTime month;
  final int total;

  COVIDData(this.month, this.total);
}

class COVIDGraphData {
  final List covidDataList;

  COVIDGraphData({this.covidDataList});

  List get getDeceased => covidDataList;

  factory COVIDGraphData.fromJson(List<dynamic> json) {
    return COVIDGraphData(
      covidDataList: json,
    );
  }
}

Future<COVIDGraphData> fetchCOVIDData() async {
  final response = await http.get(
      'https://api.apify.com/v2/datasets/sFSef5gfYg3soj8mb/items?format=json&clean=1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return COVIDGraphData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load COVID data');
  }
}

class MultipleChartState extends State<MultipleChart> {
  Map<String, int> confirmedDataMap = Map();
  Map<String, int> recoveredDataMap = Map();
  Map<String, int> deceasedDataMap = Map();
  DateTime date;
  String formattedDate;
  Future<COVIDGraphData> futureCOVIDGraphData;

  static List<charts.Series<COVIDData, DateTime>> _createData(
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
    futureCOVIDGraphData = fetchCOVIDData();
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
                  child: FutureBuilder<COVIDGraphData>(
                    future: futureCOVIDGraphData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        for (var data in snapshot.data.covidDataList) {
                          date = DateTime.parse(data['lastUpdatedAtApify']);
                          formattedDate = DateFormat.yM().format(date);
                          confirmedDataMap[formattedDate] = data['infected'];
                          recoveredDataMap[formattedDate] = data['recovered'];
                          deceasedDataMap[formattedDate] = data['deceased'];
                        }
                        print('multiple confirmed $confirmedDataMap');
                        print('multiple recovered $recoveredDataMap');
                        print('multiple deceased $deceasedDataMap');
                        return new charts.TimeSeriesChart(
                          _createData(confirmedDataMap,recoveredDataMap,deceasedDataMap),
                          animate: true,
                          behaviors: [new charts.SeriesLegend()],
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Center(child: CircularProgressIndicator());
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