import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../provider/data_provider.dart';
import '../screens/login_screen.dart';
import '../screens/student_list.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StartupPage extends StatefulWidget {
  StartupPage({Key? key}) : super(key: key);

  @override
  _StartupPageState createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  var password = "";

  @override
  void didChangeDependencies() async {
    password = await test();
    super.didChangeDependencies();
  }

  Future<String> test() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    String counter = await (prefs.getString("pass") ?? "");
    return counter;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_element

    final _currentUser = FirebaseAuth.instance.currentUser;
    //FirebaseAuth.instance.signOut();
    var userData = {};
    var appData = Provider.of<DataProvider>(context, listen: false);
    if (_currentUser != null) {
      setState(() {
        userData = appData.user;
      });
    }

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        appData.strapiLogin(_currentUser?.email, password);
        appData.getUserData(_currentUser?.email);
        if (user == null) {
          return LoginScreen();
        } else {
          return StudentList();
        }
      },
    );
  }
}
