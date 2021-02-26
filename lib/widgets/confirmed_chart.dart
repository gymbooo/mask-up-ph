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
  final List confirmedList;

  COVIDGraphData({this.confirmedList});

  List get getConfirmed => confirmedList;

  factory COVIDGraphData.fromJson(List<dynamic> json) {
    return COVIDGraphData(
      confirmedList: json,
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

class ConfirmedChartState extends State<ConfirmedChart> {
  Map<String, int> mapData = Map();
  DateTime date;
  String formattedDate;
  Future<COVIDGraphData> futureCOVIDGraphData;

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
                  "COVID 19 Total Confirmed Cases",
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
                        for (var data in snapshot.data.confirmedList) {
                          date = DateTime.parse(data['lastUpdatedAtApify']);
                          formattedDate = DateFormat.yM().format(date);
                          mapData[formattedDate] = data['infected'];
                        }
                        print('confirmed $mapData');
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