import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_hacker_app/blocs/stories_bloc.dart';
import 'package:news_hacker_app/helpers/database_helper.dart';
import 'package:news_hacker_app/models/stories_model.dart';
import 'package:get/get.dart';
import 'package:news_hacker_app/theme/constant.dart';
import 'package:news_hacker_app/theme/strings.dart';
import 'package:time_formatter/time_formatter.dart';

class NewsDetails extends StatefulWidget {

  final StoriesModel storiesModel;

  const NewsDetails({Key key, this.storiesModel}) : super(key: key);

  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  var storiesBloc = BlocProvider.getBloc<StoriesBloc>();

  DatabaseHelper helper = DatabaseHelper();

  @override
  void initState() {
    storiesBloc.loadCommentsSizePage();
    storiesBloc.commentKidsListById;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formatted = formatTime(widget.storiesModel.time);
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
          widget.storiesModel.by,
          style: contentBlack,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(
                Icons.favorite,
                color: textBlack,
              ),
              onPressed: () async {
                await storiesBloc.saveNewsBloc(widget.storiesModel.id);
              }),
        ],
      ),
      body: Container(
        height: ScreenUtil.screenHeight,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                readOnly: true,
                minLines: 1,
                maxLines: 10,
                style: contentGrey,
                textInputAction: null,
                initialValue: widget.storiesModel.title,
                decoration: InputDecoration(
                  filled: true,
                  enabledBorder: new OutlineInputBorder(
                      borderSide: new BorderSide(color: textBlack)),
                  focusedBorder: new OutlineInputBorder(
                      borderSide: new BorderSide(color: textBlack)),
                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    formatted,
                    style: contentGrey,
                  ),
                  Spacer(),
                  Icon(
                    Icons.star,
                    color: yellowAccent,
                  ),
                  Text(
                    '${widget.storiesModel.score}',
                    style: contentGrey,
                  )
                ],
              ),
            ),
            Flexible(
              child: StreamBuilder<List>(
                  initialData: [],
                  stream: storiesBloc.commentKidsListById,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Center(
                          child: Text(
                            Strings.NO_FILE,
                            style: contentWhite,
                          ),
                        );
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(
                              valueColor:
                                  new AlwaysStoppedAnimation<Color>(textBlack),
                              strokeWidth: 7.0),
                        );
                      default:
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (_, __) => const SizedBox(
                        height: 20,
                      ),
                      itemCount: widget.storiesModel.kids.length,
                      itemBuilder: (context, int index) {
                        StoriesModel news = snapshot.data[index];
                        return widget.storiesModel.kids.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Html(
                                      padding: EdgeInsets.all(8),
                                      backgroundColor:
                                          white,
                                      defaultTextStyle: contentGrey,
                                      renderNewlines: true,
                                      data: news.text,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(Icons.person, color: yellowAccent),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          news.by,
                                          style: contentGrey,
                                        )
                                      ],
                                    ),
                                    Divider(
                                      thickness: 4,
                                      color: appBackground,
                                    ),
                                  ],
                                ),
                              )
                            : Center(
                                child: Text(
                                  Strings.NO_COMMENTS,
                                  style: contentWhite,
                                ),
                              );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
