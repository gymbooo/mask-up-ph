import 'package:flutter/material.dart';
import 'package:flutterauth0/DataSource.dart';
import 'package:flutterauth0/widgets/consts.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        title: Text('FAQs'),
      ),
      body: ListView.builder(
          itemCount: DataSource.questionAnswers.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(
                DataSource.questionAnswers[index]['question'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(DataSource.questionAnswers[index]['answer']),
                )
              ],
            );
          }),
    );
  }
}
