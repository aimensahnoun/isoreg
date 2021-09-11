import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isoregistration/provider/data_provider.dart';
import 'package:isoregistration/screens/logs_search.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/custom_icons_icons.dart';
import '../widgets/drawer.dart';
import "../helpers/app_config.dart" as config;
import 'dart:io' show Platform;

class LogsPage extends StatefulWidget {
  LogsPage({Key? key}) : super(key: key);

  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  @override
  void initState() {
    Provider.of<DataProvider>(context, listen: false).fetchLogs();
    Provider.of<DataProvider>(context, listen: false).getApplis();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var logs = Provider.of<DataProvider>(context, listen: true).logs;

    // print(logs);
    var isDrawerOpen = false;
    return Scaffold(
      drawer: CustomDrawer(
        index: 2,
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
                    builder: (BuildContext ctx) => LogSearch(
                          logs: logs,
                        )));
              }
            }
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Logs",
                        style: TextStyle(
                          fontSize: Platform.isIOS
                              ? config.App(context).appHeight(3)
                              : config.App(context).appHeight(3.5),
                          fontFamily: "Proxima",
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext ctx) => LogSearch(
                                    logs: logs,
                                  )));
                        },
                        icon: Icon(
                          CustomIcons.search_alt,
                          size: Platform.isIOS
                              ? config.App(context).appHeight(4)
                              : config.App(context).appHeight(4.5),
                        ),
                        color: Colors.black,
                      )
                    ],
                  ),
                  SizedBox(
                    height: Platform.isIOS
                        ? config.App(context).appHeight(3)
                        : config.App(context).appHeight(3.5),
                  ),
                  Expanded(
                    child: LiquidPullToRefresh(
                      onRefresh: () async {
                        Provider.of<DataProvider>(context, listen: false)
                            .fetchLogs();
                      },
                      showChildOpacityTransition: false,
                      child: ListView.builder(
                        itemCount: logs.length,
                        itemBuilder: (context, i) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            width: double.infinity,
                            height: Platform.isIOS
                                ? config.App(context).appHeight(17)
                                : config.App(context).appHeight(27),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Message : ${logs[i]["message"]}",
                                    style: TextStyle(
                                      fontSize: Platform.isIOS
                                          ? config.App(context).appHeight(2)
                                          : config.App(context).appHeight(2.5),
                                      fontFamily: "Proxima",
                                    ),
                                  ),
                                  SizedBox(
                                      height: Platform.isIOS
                                          ? config.App(context).appHeight(2)
                                          : config.App(context).appHeight(2.5)),
                                  Text(
                                    "Time : ${logs[i]["time"]}",
                                    style: TextStyle(
                                      fontSize: Platform.isIOS
                                          ? config.App(context).appHeight(2)
                                          : config.App(context).appHeight(2.5),
                                      fontFamily: "Proxima",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
