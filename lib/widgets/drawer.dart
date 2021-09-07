import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:isoregistration/screens/login_screen.dart';
import "package:provider/provider.dart";
import '../helpers/custom_icons_icons.dart';
import '../provider/data_provider.dart';
import '../screens/logs.dart';
import '../screens/stats.dart';
import '../screens/student_list.dart';
import "../helpers/app_config.dart" as config;
import 'dart:io' show Platform;

class CustomDrawer extends StatefulWidget {
  CustomDrawer({required this.index});

  int index;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<DataProvider>(context, listen: false).user;
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 40.0,
          horizontal: 20,
        ),
        child: ListView(
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: Platform.isIOS
                      ? config.App(context).appWidth(20)
                      : config.App(context).appWidth(15)),
              child: Text(
                user["name"],
                maxLines: 3,
                style: TextStyle(
                    fontFamily: "Proxima",
                    fontSize: Platform.isIOS
                        ? config.App(context).appHeight(2.5)
                        : config.App(context).appHeight(3)),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: Platform.isIOS
                  ? config.App(context).appHeight(4)
                  : config.App(context).appHeight(4.5),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                if (widget.index != 0) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => StudentList()));
                }
              },
              child: Row(
                children: [
                  Icon(CustomIcons.list_ui_alt),
                  SizedBox(
                      width: Platform.isIOS
                          ? config.App(context).appWidth(3)
                          : config.App(context).appWidth(3.5)),
                  Text(
                    "Students List",
                    style: TextStyle(
                      fontFamily: "Proxima",
                      fontSize: Platform.isIOS
                          ? config.App(context).appHeight(2)
                          : config.App(context).appHeight(2.5),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: Platform.isIOS
                    ? config.App(context).appHeight(2)
                    : config.App(context).appHeight(2.5)),
            user["type"] != "admin"
                ? Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          if (widget.index != 1) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => Stats()));
                          }
                        },
                        child: Row(
                          children: [
                            Icon(CustomIcons.analysis),
                            SizedBox(
                              width: Platform.isIOS
                                  ? config.App(context).appWidth(3)
                                  : config.App(context).appWidth(3.5),
                            ),
                            Text(
                              "Statistics",
                              style: TextStyle(
                                fontFamily: "Proxima",
                                fontSize: Platform.isIOS
                                    ? config.App(context).appHeight(2)
                                    : config.App(context).appHeight(2.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Platform.isIOS
                            ? config.App(context).appHeight(2)
                            : config.App(context).appHeight(2.5),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          if (widget.index != 2) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => LogsPage()));
                          }
                        },
                        child: Row(
                          children: [
                            Icon(CustomIcons.clipboard_notes),
                            SizedBox(
                              width: Platform.isIOS
                                  ? config.App(context).appWidth(3)
                                  : config.App(context).appWidth(3.5),
                            ),
                            Text(
                              "Logs",
                              style: TextStyle(
                                fontFamily: "Proxima",
                                fontSize: Platform.isIOS
                                    ? config.App(context).appHeight(2)
                                    : config.App(context).appHeight(2.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(
              height: config.App(context).appHeight(40),
            ),
            InkWell(
              onTap: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                await auth.signOut();
                //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                //       builder: (BuildContext ctx) => LoginScreen()));
                // },
              },
              child: Row(
                children: [
                  Icon(CustomIcons.sign_out_alt),
                  SizedBox(
                    width: Platform.isIOS
                        ? config.App(context).appWidth(3)
                        : config.App(context).appWidth(3.5),
                  ),
                  Text(
                    "Logout",
                    style: TextStyle(
                      fontFamily: "Proxima",
                      fontSize: Platform.isIOS
                          ? config.App(context).appHeight(2)
                          : config.App(context).appHeight(2.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
