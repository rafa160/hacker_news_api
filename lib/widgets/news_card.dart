import 'package:flutter/material.dart';
import 'package:news_hacker_app/models/stories_model.dart';
import 'package:news_hacker_app/theme/constant.dart';

class NewsCard extends StatelessWidget {

  final StoriesModel model;

  const NewsCard({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 2.0, color: Colors.white24))),
          child: Icon(Icons.sort, color: Colors.white),
        ),
        title: Text(model.title, style: contentWhite,),
        subtitle: Row(
          children: <Widget>[
            Icon(Icons.person, color: primary),
            SizedBox(
              width: 10,
            ),
            Text(model.by, style: subContentGrey,),
          ],
        ),
        trailing: Text(model.score.toString(), style: contentWhite,),
      ),
    );
  }
}
