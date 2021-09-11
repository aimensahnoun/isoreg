// ignore_for_file: await_only_futures

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/data_provider.dart';
import '../screens/create_new_profile.dart';
import '../screens/search.dart';
import '../screens/student_details.dart';
import '../widgets/drawer.dart';
import '../widgets/student_card.dart';

import "../helpers/app_config.dart" as config;
import "../helpers/custom_icons_icons.dart";
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class StudentList extends StatefulWidget {
  const StudentList({Key? key}) : super(key: key);

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  @override
  void didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var password = await prefs.getString("pass");
    var email = FirebaseAuth.instance.currentUser?.email;
    Provider.of<DataProvider>(context, listen: false)
        .strapiLogin(email, password!);
    var jwt = await prefs.getString("jwt");

    Provider.of<DataProvider>(context, listen: false)
        .getUserData(config.convertString(email!));
    Provider.of<DataProvider>(context, listen: false).fetchStudent();
    Provider.of<DataProvider>(context, listen: false).fetchStats();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isDrawerOpen = false;
    return Scaffold(
      drawer: CustomDrawer(
        index: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0054A1),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext) => CreateNewProfile(),
            ),
          );
        },
        child: Icon(
          CustomIcons.plus,
        ),
      ),
      body: Builder(
        builder: (context) => GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              Scaffold.of(context).openDrawer();
              isDrawerOpen = true;
            } else if (details.delta.dx < 0) {
              if (isDrawerOpen) {
                Navigator.of(context).pop();
                isDrawerOpen = false;
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext ctx) => Search(),
                ));
              }
            }
          },
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Student List",
                        style: TextStyle(
                            fontFamily: "Proxima",
                            fontSize: Platform.isIOS
                                ? config.App(context).appHeight(4)
                                : config.App(context).appHeight(4.5)),
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext ctx) => Search(),
                            ),
                          );
                        },
                        icon: Icon(
                          CustomIcons.search_alt,
                          size: Platform.isIOS
                              ? config.App(context).appHeight(4)
                              : config.App(context).appHeight(4.5),
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                Provider.of<DataProvider>(context).students.length == 0
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Expanded(
                        child: LiquidPullToRefresh(
                        onRefresh: () async {
                          Provider.of<DataProvider>(context, listen: false)
                              .fetchStudent();
                        },
                        showChildOpacityTransition: false,
                        child: ListView.builder(
                          itemBuilder: (ctx, i) => StudentCard(
                            student:
                                Provider.of<DataProvider>(context).students[i],
                          ),
                          itemCount: Provider.of<DataProvider>(context)
                              .students
                              .length,
                        ),
                      ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
