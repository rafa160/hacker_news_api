import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_hacker_app/models/local_data_model.dart';
import 'package:news_hacker_app/theme/constant.dart';
import 'package:get/get.dart';
import 'package:news_hacker_app/theme/strings.dart';
import 'package:news_hacker_app/widgets/local_data_card.dart';

class MyFavoriteNewsScreen extends StatefulWidget {
  final List list;

  const MyFavoriteNewsScreen({Key key, this.list}) : super(key: key);
  @override
  _MyFavoriteNewsScreenState createState() => _MyFavoriteNewsScreenState();
}

class _MyFavoriteNewsScreenState extends State<MyFavoriteNewsScreen> {

  List<LocalData> item = [];


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Image.asset(
            Strings.BTN_CLOSE_BUTTON,
            scale: 3,
          ),
        ),
        title: Text(
          Strings.FAV_TITLE,
          style: contentBlack,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        height: ScreenUtil.screenHeight,
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(
                    height: 5,
                  ),
              itemCount: widget.list.length,
              itemBuilder: (BuildContext context, int index) {
                var news = widget.list[index];
                return LocalDataCard(
                  localData: news,
                );
              }),
        ),
      ),
    );
  }
}
