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

  NewsData({this.status, this.totalResults, this.articles});

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: json['articles'],
    );
  }
}

Future<NewsData> fetchNewsData() async {
  final response = await http.get(
      'https://newsapi.org/v2/top-headlines?country=ph&q=covid&apiKey=5abd16290a0b41c685b08bdf15883c5f');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return NewsData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class _NewsState extends State<News> {
  Future<NewsData> futureNewsData;
  String status;
  int totalResults;
  List<dynamic> articles;
  List<dynamic> listOfArticles = [];

  @override
  void initState() {
    super.initState();
    futureNewsData = fetchNewsData();
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(left: 15, top: 25, bottom: 10),
              child: Text(
                'Top Headlines on COVID-19\nin the Philippines',
                style: GoogleFonts.montserrat(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFEEEEEE)),
              ),
            ),
            Expanded(
              child: FutureBuilder<NewsData>(
                  future: futureNewsData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      articles = snapshot.data.articles;
                      for (var a in articles) {
                        listOfArticles.add(a);
                      }
                      print('loa $listOfArticles');
                      return buildListView(
                          status: snapshot.data.status,
                          totalResults: snapshot.data.totalResults,
                          articles: listOfArticles);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ]),
        ),
      ),
    );
  }

  RefreshIndicator buildListView({
    String status,
    int totalResults,
    List<dynamic> articles,
  }) {
    return RefreshIndicator(
      child: ListView.builder(
        itemCount: totalResults - 1,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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
                      style: GoogleFonts.montserrat(
                          fontSize: 17, color: const Color(0xFFEEEEEE)),
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
                            fontStyle: FontStyle.italic,
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
                          fontStyle: FontStyle.italic,
                          color: Colors.black.withOpacity(0.5)),
                    ),
                  )
                ],
              ),
              margin:
                  EdgeInsets.only(top: 5, right: 15.0, left: 15.0, bottom: 5));
        },
      ),
      onRefresh: fetchNewsData,
    );
  }
}