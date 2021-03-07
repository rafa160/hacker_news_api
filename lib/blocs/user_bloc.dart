import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:news_hacker_app/helpers/firebase_errors.dart';
import 'package:news_hacker_app/models/user_model.dart';
import 'package:news_hacker_app/screens/main_screen.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends BlocBase {
  UserBloc() {
    _loadCurrentUser();
  }

  FirebaseUser firebaseUser;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final _user$ = BehaviorSubject<UserModel>.seeded(null);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _fireStore = Firestore.instance;

  Sink<UserModel> get userIn => _user$.sink;

  Stream<UserModel> get userOut => _user$.stream
      .asyncMap((v) async {
        if (v == null) {
          return await get<UserModel>('user',
              construct: (v) => UserModel.fromJson(v));
        } else {
          return v;
        }
      })
      .share()
      .cast<UserModel>();

  Future get<S>(String key, {S Function(Map) construct}) async {
    try {
      SharedPreferences share = await _prefs;
      String value = share.getString(key);
      Map<String, dynamic> json = jsonDecode(value);
      if (construct == null) {
        return json;
      } else {
        return construct(json);
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> _saveUserLocally(Map<String, dynamic> json) async {
    try {
      SharedPreferences share = await _prefs;
      share.setString('user', jsonEncode(json));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel> loggedUserAsync() async {
    return await get<UserModel>("user",
        construct: (v) => UserModel.fromJson(v));
  }

  Future<DocumentSnapshot> getUser({String userId}) async {
    String id;

    if (userId == null) {
      var loggedUser = await loggedUserAsync();
      if (loggedUser == null) return null;
      id = loggedUser.id;
    } else {
      id = userId;
    }

    DocumentSnapshot documentSnapshot =
    await Firestore.instance.collection("users").document(id).get();

    return documentSnapshot.exists ? documentSnapshot : null;
  }

  Future _saveUserData() async {
    if (firebaseUser == null) {
      signOut();
    }

    Map<String, dynamic> userData = {
      "id": firebaseUser.uid,
      "email": firebaseUser.email,
    };

    DocumentSnapshot userModel = await getUser(userId: firebaseUser.uid);

    if (userModel == null) {
      await _fireStore
          .collection('users')
          .document(firebaseUser.uid)
          .setData(userData);
    } else {
      if (userModel.data["photo"] != null) {
        userData["photo"] = userModel.data["photo"];
      }

      await _fireStore
          .collection('users')
          .document(firebaseUser.uid)
          .updateData(userData);
    }

    await _saveUserLocally(userData);
    userIn.add(UserModel.fromJson(userData));
  }

  Future _loadCurrentUser() async {
    firebaseUser = await _auth.currentUser();
  }

  Future<bool> isLogged() async {
    var preference = await _prefs;
    return preference.get('user') != null;
  }

  Future<FirebaseUser> SignIn(
      String email, String password, BuildContext context) async {
    EasyLoading.show(
      status: 'loading...',
    );
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      firebaseUser = value.user;

      if (firebaseUser == null) {
        return null;
      }

      await _saveUserData();
      await isLogged();
      EasyLoading.dismiss();
      await Get.offAll(MainScreen());
    }).catchError((e) {
      EasyLoading.dismiss();

      var error = getErrorString(e.code);

      if (e.code != null) {
        Fluttertoast.showToast(
            msg: error,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 12.0);
      }
    });

    return firebaseUser;
  }

  Future signOut() async {
    await _auth.signOut();
    firebaseUser = null;
    userIn.add(null);
    _deleteUserLocally();
  }

  void _deleteUserLocally() async {
    var preference = await _prefs;
    preference.clear();
  }

  @override
  void dispose() {
    _user$.close();
    super.dispose();
  }
}
