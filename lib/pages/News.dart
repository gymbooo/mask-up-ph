import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  List<Article> articles;

  NewsData(this.status, this.totalResults, this.articles);
}

class _NewsState extends State<News> {
  final String url =
      'https://newsapi.org/v2/top-headlines?country=ph&q=covid&apiKey=5abd16290a0b41c685b08bdf15883c5f';
  NewsData newsData;
  String status;
  int totalResults;
  List<dynamic> articles;

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
      print(newsData);
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ListView(children: [
        Text('$status'),
        Text('$totalResults'),
        Text('$articles')
      ]),
    ));
  }
}

//--------with future builder

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//             child: FutureBuilder<String>(
//       future: getJsonData(),
//       builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//         if (snapshot.hasData) {
//           return ListView(children: [
//             Text('$status'),
//             Text('$totalResults'),
//           ]);
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       },
//     )));
//   }
// }