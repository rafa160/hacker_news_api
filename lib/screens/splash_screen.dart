import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_hacker_app/blocs/user_bloc.dart';
import 'package:news_hacker_app/screens/login_screen.dart';
import 'package:news_hacker_app/screens/main_screen.dart';
import 'package:news_hacker_app/theme/constant.dart';
import 'package:get/get.dart';
import 'package:news_hacker_app/theme/strings.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var userBloc = BlocProvider.getBloc<UserBloc>();

  Future _redirectToHome() async {
    if (await userBloc.isLogged() == true) {
      await Get.offAll(MainScreen());
    }  else {
      await Get.offAll(LoginScreen());
    }
  }

  @override
  void initState() {
    _redirectToHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      color: backgroundColor,
      child: Center(
        child: Text(
          Strings.APP_NAME,
          style: titleAppName,
        ),
      ),
    );
  }
}
