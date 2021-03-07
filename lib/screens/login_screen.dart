import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_hacker_app/blocs/user_bloc.dart';
import 'package:news_hacker_app/theme/constant.dart';
import 'package:news_hacker_app/theme/strings.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var userBloc = BlocProvider.getBloc<UserBloc>();

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: ScreenUtil.screenHeight * 0.3,
                ),
                Text(
                  Strings.APP_NAME,
                  style: titleAppName,
                ),
                SizedBox(
                  height: 80,
                ),
                FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          initialValue: null,
                          name: 'email',
                          style: contentWhite,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                            FormBuilderValidators.email(context),
                          ]),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            focusedBorder: new OutlineInputBorder(
                                borderSide: new BorderSide(color: textBlack)),
                              border: new OutlineInputBorder(
                                  borderSide: new BorderSide(color: textBlack)),
                              contentPadding:
                              EdgeInsets.only(left: 15.0, top: 15.0),
                              hintText: Strings.EMAIL_HINT,
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(128, 128, 128, 1))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FormBuilderTextField(
                          initialValue: null,
                          name: 'password',
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context),
                          ]),
                          style: contentWhite,
                          maxLines: 1,
                          obscureText: true,
                          decoration: InputDecoration(
                              focusedBorder: new OutlineInputBorder(
                                  borderSide: new BorderSide(color: textBlack)),
                              border: new OutlineInputBorder(
                                  borderSide: new BorderSide(color: textBlack)),
                              counterText: '',
                              contentPadding:
                              EdgeInsets.only(left: 15.0, top: 15.0),
                              hintText: Strings.PASSWORD_HINT,
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(128, 128, 128, 1))),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: ScreenUtil.screenWidth,
                          child: ButtonTheme(
                            minWidth: ScreenUtil.screenWidth,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: white,
                                elevation: 1,
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10.0)),
                              ),
                              child: Text(
                                Strings.BUTTON_LOGIN,
                                style: contentGrey,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  await userBloc.SignIn(
                                      _formKey.currentState.value['email'],
                                      _formKey.currentState.value['password'],
                                      context);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
