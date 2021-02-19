import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutterauth0/widgets/consts.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class Source {
  String id = "";
  String name = "";

  Source(this.id, this.name);
}

class Article {
  Source source = Source("id", "name");
  String author = "";
  String title = "";
  String description = "";
  String url = "";
  String urlToImage = "";
  String publishedAt = "";
  String content = "";

  Article(this.source, this.author, this.title, this.description, this.url,
      this.urlToImage, this.publishedAt, this.content);
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
                return ListView.builder(
                  itemCount: totalResults - 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: const Color(0xFF32A373),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(15),
                          leading: (listOfArticles[index]['urlToImage'] == null)
                              ? Image.asset(
                                  'lib/assets/images/news.png',
                                )
                              : Image.network(
                                  listOfArticles[index]['urlToImage'],
                                ),
                          title: Text(
                            listOfArticles[index]['title'].toString() ?? '',
                            style: TextStyle(
                                fontSize: 18,
                                color: const Color(0xFFEEEEEE),
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            listOfArticles[index]['content'] ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          onTap: () {
                            launch(listOfArticles[index]['url']);
                          },
                        ),
                        margin: EdgeInsets.only(
                            top: 7.5, right: 25.0, left: 25.0, bottom: 7.5));
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ))),
    );
  }
}
