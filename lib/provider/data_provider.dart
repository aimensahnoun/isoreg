import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "../helpers/app_config.dart" as config;
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider extends ChangeNotifier {
  List students = [];
  var user = {};
  var stats = [];
  var applis = [];
  var logs = [];
  var bachApplis = [];
  var masterApplis = [];
  var bachlorStats = [];
  var mastersStats = [];

  String jwt = "";
  var test = FirebaseFirestore.instance.collection("students").snapshots();

  // void fetchUserData(var id) async {
  //   final snapShot =
  //       await FirebaseFirestore.instance.collection("users").doc(id).get();
  //   this.user = snapShot.data()!;
  //   notifyListeners();
  // }

  void getStats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jwt = await prefs.getString("jwt");
    var url = Uri.parse("https://isoreg.herokuapp.com/stats?_limit=${1000000}");
    http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${jwt}",
      },
    );

    var decodedData2;

    if (response.statusCode == 200) {
      String data = response.body;
      this.stats = jsonDecode(data);
    } else {}
  }

  void fetchStudent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jwt = await prefs.getString("jwt");
    var url =
        Uri.parse("https://isoreg.herokuapp.com/students?_limit=${1000000}");
    http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${jwt}",
      },
    );
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        students = decodedData;
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void getApplis() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jwt = await prefs.getString("jwt");
    var url2 = Uri.parse("https://isoreg.herokuapp.com/applis");
    http.Response response2 = await http.get(
      url2,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${jwt}",
      },
    );
    var decodedData;
    if (response2.statusCode == 200) {
      String data = response2.body;
      applis = await jsonDecode(data);
      var temp = applis.where((element) => element["slug"] == "bachlors");
      var tempMs = applis.where((element) => element["slug"] == "masters");
      bachApplis = temp.toList();
      masterApplis = tempMs.toList();
    } else {}
  }

  void strapiLogin(var email, String password) async {
    var url = Uri.parse("https://isoreg.herokuapp.com/auth/local");
    http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'identifier': email, "password": password}),
    );
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt', decodedData["jwt"]);
      this.setJWT(decodedData["jwt"]);
    }
  }

  void getUserData(var email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jwt = await prefs.getString("jwt");
    var em = config.convertString(email);
    var url = Uri.parse("https://isoreg.herokuapp.com/workers/${em}");
    http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${jwt}",
      },
    );
    if (response.statusCode == 200) {
      String data = await response.body;
      var decodedData = jsonDecode(data);

      this.user = decodedData;

      notifyListeners();
    } else {
      print(response.body);
    }
  }

  void setJWT(String jwt) {
    this.jwt = jwt;
  }

  void fetchLogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jwt = await prefs.getString("jwt");
    var url =
        Uri.parse("https://isoreg.herokuapp.com/tracks?_limit=${1000000}");
    http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${jwt}",
      },
    );
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        logs = decodedData;
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void fetchStats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jwt = await prefs.getString("jwt");
    var url = Uri.parse("https://isoreg.herokuapp.com/stats?_limit=${1000000}");
    http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer ${jwt}",
      },
    );
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);

        var temp =
            decodedData!.where((element) => element["type"] == "Bachlors");
        var tempMs =
            decodedData!.where((element) => element["type"] == "Masters");
        stats = decodedData;
        bachlorStats = temp.toList();
        mastersStats = tempMs.toList();
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
