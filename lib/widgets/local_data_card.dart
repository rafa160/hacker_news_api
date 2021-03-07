import 'package:flutter/material.dart';
import 'package:news_hacker_app/models/local_data_model.dart';

import 'package:news_hacker_app/theme/constant.dart';

class LocalDataCard extends StatelessWidget {

  final LocalData localData;

  const LocalDataCard({Key key, this.localData}) : super(key: key);

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
        title: Text(localData.title, style: contentWhite,),
        subtitle: Row(
          children: <Widget>[
            Icon(Icons.person, color: yellowAccent),
            SizedBox(
              width: 10,
            ),
            Text(localData.by, style: subContentGrey,),
          ],
        ),
      ),
    );
  }
}
