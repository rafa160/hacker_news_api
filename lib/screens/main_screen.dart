import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_hacker_app/blocs/stories_bloc.dart';
import 'package:news_hacker_app/blocs/user_bloc.dart';
import 'package:news_hacker_app/helpers/database_helper.dart';
import 'package:news_hacker_app/models/stories_model.dart';
import 'package:news_hacker_app/screens/login_screen.dart';
import 'package:news_hacker_app/screens/my_favorite_news_screen.dart';
import 'package:news_hacker_app/screens/news_details.dart';
import 'package:news_hacker_app/theme/constant.dart';
import 'package:news_hacker_app/theme/strings.dart';
import 'package:news_hacker_app/widgets/news_card.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var userBloc = BlocProvider.getBloc<UserBloc>();
  var storiesBloc = BlocProvider.getBloc<StoriesBloc>();
  DatabaseHelper helper = DatabaseHelper();

  @override
  void initState() {
    storiesBloc.topStories;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        title: Text(Strings.TITLE_MAIN_PAGE, style: appSubTitle),
        centerTitle: true,
        backgroundColor: white,
        actions: [
          IconButton(
              icon: Icon(
                Icons.favorite,
                color: textBlack,
              ),
              onPressed: () async {
                List list = await helper.getAllSavedNews();
                  Get.to(MyFavoriteNewsScreen(list: list,));
              }
          ),
          IconButton(
              icon: Icon(
                Icons.login,
                color: textBlack,
              ),
              onPressed: () async {
                await userBloc.signOut();
                Get.offAll(LoginScreen());
              })
        ],
      ),
      body: StreamBuilder<List>(
          initialData: [],
          stream: storiesBloc.topStories,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text(Strings.NO_FILE),
                );
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(textBlack),
                      strokeWidth: 7.0),
                );
              default:
            }
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListView.separated(
                separatorBuilder: (_, __) => const SizedBox(
                  height: 5,
                ),
                itemCount: storiesBloc.newsTopList.length,
                itemBuilder: (BuildContext context, int index) {
                  StoriesModel news = snapshot.data[index];
                  return GestureDetector(
                      onTap: () async {
                        EasyLoading.show(
                          status: 'loading...',
                        );
                        StoriesModel newsId =  await storiesBloc.loadNewById(news.id);
                       await storiesBloc.loadCommentsById(news.id);
                        Get.to(NewsDetails(storiesModel: newsId,));
                        EasyLoading.dismiss();
                      } ,
                      child: NewsCard(model: snapshot.data[index]));
                },
              ),
            );
          }),
    );
  }
}
