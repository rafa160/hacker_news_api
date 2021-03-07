import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:news_hacker_app/blocs/stories_bloc.dart';
import 'package:news_hacker_app/blocs/user_bloc.dart';

void main() {
  runApp(BlocProvider(
    blocs: [
      Bloc((i) => UserBloc()),
      Bloc((i) => StoriesBloc())
    ],
    child: GetMaterialApp(
      title: "News Hacker",
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: SplashScreen(),
    ),
  ));
}