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
  final List recoveredList;

  COVIDGraphData({this.recoveredList});

  List get getDeceased => recoveredList;

  factory COVIDGraphData.fromJson(List<dynamic> json) {
    return COVIDGraphData(
      recoveredList: json,
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

class RecoveredChartState extends State<RecoveredChart> {
  Map<String, int> mapData = Map();
  DateTime date;
  String formattedDate;
  Future<COVIDGraphData> futureCOVIDGraphData;

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
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (RecoveredData recovered, _) => recovered.month,
        measureFn: (RecoveredData recovered, _) => recovered.total,
        data: data,
      )
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
                  "COVID 19 Total Recovered Cases",
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
                        for (var data in snapshot.data.recoveredList) {
                          date = DateTime.parse(data['lastUpdatedAtApify']);
                          formattedDate = DateFormat.yM().format(date);
                          mapData[formattedDate] = data['recovered'];
                        }
                        print('deceased $mapData');
                        return new charts.TimeSeriesChart(
                          _createData(mapData),
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