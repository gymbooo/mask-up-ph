import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class NewsData {
  String status;
  int totalResults;
  List<dynamic> articles;

  NewsData(this.status, this.totalResults, this.articles);
}

class _NewsState extends State<News> {
  final String url =
      'https://newsapi.org/v2/top-headlines?country=ph&q=covid&apiKey=5abd16290a0b41c685b08bdf15883c5f';
  NewsData newsData;
  String status;
  int totalResults;
  List<dynamic> articles;
  List<dynamic> listOfArticles = [];

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      status = convertDataToJson['status'];
      totalResults = convertDataToJson['totalResults'];
      articles = convertDataToJson['articles'];
      newsData = NewsData(status, totalResults, articles);

      for (var a in articles) {
        listOfArticles.add(a);
      }
      print('loa $listOfArticles');
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/images/background.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: FutureBuilder<String>(
            future: getJsonData(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15, top: 25, bottom: 10),
                        child: Text(
                          'Top Headlines on COVID-19\nin the Philippines',
                          style: GoogleFonts.amaranth(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFEEEEEE)),
                        ),
                      ),
                      Expanded(child: buildListView())
                    ]);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: totalResults - 1,
      itemBuilder: (BuildContext context, int index) {
        return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: const Color(0xFF32A373),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ListTile(
                  contentPadding:
                      EdgeInsets.only(top: 6, right: 14.0, left: 14.0),
                  leading: (listOfArticles[index]['urlToImage'] == null)
                      ? Image.asset(
                          'lib/assets/images/news.png',
                          width: 80,
                        )
                      : Image.network(
                          listOfArticles[index]['urlToImage'],
                          width: 80,
                        ),
                  title: Text(
                    listOfArticles[index]['title'] ?? 'Title not found',
                    style:
                        GoogleFonts.buenard(fontSize: 19, color: const Color(0xFFEEEEEE)),
                  ),
                  subtitle: Text(
                    listOfArticles[index]['content'] ?? 'Tap to see content',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  onTap: () {
                    launch(listOfArticles[index]['url']);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(right: 14, top: 6),
                  child: Text(listOfArticles[index]['author'] ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.5)),
                      overflow: TextOverflow.ellipsis),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 14, bottom: 6),
                  child: Text(
                    DateFormat.yMMMMd('en_US').add_jm().format(DateTime.parse(
                            listOfArticles[index]['publishedAt'])) ??
                        '',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.5)),
                  ),
                )
              ],
            ),
            margin:
                EdgeInsets.only(top: 5, right: 15.0, left: 15.0, bottom: 5));
      },
    );
  }
}
