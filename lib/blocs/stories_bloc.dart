import 'dart:async';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:news_hacker_app/helpers/database_helper.dart';
import 'package:news_hacker_app/models/local_data_model.dart';
import 'package:news_hacker_app/models/stories_model.dart';
import 'package:news_hacker_app/repository/repository.dart';
import 'package:news_hacker_app/screens/main_screen.dart';
import 'package:rxdart/rxdart.dart';

class StoriesBloc extends BlocBase {

  static const int INIT_PAGE_SIZE = 100;
  static const int COMMENTS_PAGE_SIZE = 10;
  static const int PAGE_SIZE = 3;

  StoriesBloc() {
    _loadInitTopStories();
  }

  var _isLoadingMoreNews = false;
  var _currentNewsIndex = 0;

  final _repository = Repository();
  DatabaseHelper helper = DatabaseHelper();

  List<int> _newsIdList = [];
  StoriesModel newsItemsModel;
  List<StoriesModel> newsTopList = [];
  List<StoriesModel> newsKidsList = [];
  LocalData localData = LocalData();

  StreamController<List<StoriesModel>> _topStoriesStreamController = BehaviorSubject();
  StreamController<List<StoriesModel>> _commentsStreamController = BehaviorSubject();

  Stream<List<StoriesModel>> get topStories => _topStoriesStreamController.stream;
  Stream<List<StoriesModel>> get commentKidsListById => _commentsStreamController.stream;

  Future<void> _loadInitTopStories() async {
    try {
      _newsIdList.addAll(await _repository.loadNewsIds());
      loadSizeNewsPage(pageSize: INIT_PAGE_SIZE);
    } catch (e){
      await Get.offAll(MainScreen());
      Fluttertoast.showToast(
          msg: 'Erro :(',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 12.0);
    }
  }

  Future<StoriesModel> loadNewById(int id) async {
    StoriesModel news;
    try {
      news = await _repository.loadNewById(id);
    } catch (e){
      EasyLoading.dismiss();
      await Get.offAll(MainScreen());
      Fluttertoast.showToast(
          msg: 'Erro :(',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 12.0);
    }
    return news;
  }

  Future<void> loadCommentsById(int id) async {
    StoriesModel news = await _repository.loadNewById(id);
    for(int i = 0; i < news.kids.length; i++){
      int item = news.kids[i];
      newsKidsList.add(await _repository.loadNewById(item));
    }
  }

  Future<void> loadCommentsSizePage() async {
    try {
      _commentsStreamController.sink.add(newsKidsList);
    } catch (e) {
      await Get.offAll(MainScreen());
      Fluttertoast.showToast(
          msg: 'Erro :(',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 12.0);
    }
  }


  Future<void> loadSizeNewsPage({int pageSize = PAGE_SIZE}) async {
    if (_isLoadingMoreNews) return;
    _isLoadingMoreNews = true;
    final storySize = min(_currentNewsIndex + pageSize, _newsIdList.length);
    for (int index = _currentNewsIndex; index < storySize; index++) {
      newsTopList.add(await _repository.loadNewById(_newsIdList[index]));
    }
    _currentNewsIndex = newsTopList.length;
    _topStoriesStreamController.sink.add(newsTopList);
    _isLoadingMoreNews = false;
  }

  bool hasMoreNews() => _currentNewsIndex < _newsIdList.length;

  Future<void> saveNewsBloc(int id) async {
    EasyLoading.show(
      status: 'loading...',
    );
    try {
      StoriesModel news = await _repository.loadNewById(id);
      Random random = new Random();
      int randomNumber = random.nextInt(200);
      localData.id = randomNumber;
      localData.title = news.title;
      localData.by = news.by;
      helper.saveNew(localData);
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: 'Noticia adicionada aos Favoritos',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
    } catch(e){
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: 'Erro :(',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 12.0);
    }

  }

  Future<void> loadDbSavedNewsList() async {
    helper.getAllSavedNews();
  }

  @override
  void dispose() {
    super.dispose();
    _commentsStreamController.close();
    _topStoriesStreamController.close();
    _repository.dispose();
  }
}