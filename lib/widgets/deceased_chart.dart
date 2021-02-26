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
  final List deceasedList;

  COVIDGraphData({this.deceasedList});

  List get getDeceased => deceasedList;

  factory COVIDGraphData.fromJson(List<dynamic> json) {
    return COVIDGraphData(
      deceasedList: json,
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

class DeceasedChartState extends State<DeceasedChart> {
  Map<String, int> mapData = Map();
  DateTime date;
  String formattedDate;
  Future<COVIDGraphData> futureCOVIDGraphData;

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
                  "COVID 19 Total Deceased Cases",
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
                        for (var data in snapshot.data.deceasedList) {
                          date = DateTime.parse(data['lastUpdatedAtApify']);
                          formattedDate = DateFormat.yM().format(date);
                          mapData[formattedDate] = data['deceased'];
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}