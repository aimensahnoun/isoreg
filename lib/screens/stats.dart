import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isoregistration/provider/data_provider.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';
import '../widgets/student_card.dart';
import "../helpers/app_config.dart" as config;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Stats extends StatefulWidget {
  Stats({Key? key}) : super(key: key);

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  void initState() {
    Provider.of<DataProvider>(context, listen: false).fetchStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDrawerOpen = false;
    Provider.of<DataProvider>(context, listen: true).getStats();
    Provider.of<DataProvider>(context, listen: true).getApplis();
    var statss = Provider.of<DataProvider>(context).stats;
    var bachApplis = Provider.of<DataProvider>(context).bachApplis;
    var masterApplis = Provider.of<DataProvider>(context).masterApplis;
    var masterStats = Provider.of<DataProvider>(context).mastersStats;
    var bachlorStats = Provider.of<DataProvider>(context).bachlorStats;

    getSections(var data, totalStudents) {
      var bach = {
        "color": Color(0xFF015BAA),
        "value": data["bachlors"],
        "title": "BSc"
      };
      var mas = {
        "color": Color(0xFF02AEF1),
        "value": data["masters"],
        "title": "MSc"
      };
      var d = [bach, mas];
      return d
          .asMap()
          .map<int, PieChartSectionData>((key, data) {
            var percentage =
                ((int.parse(data["value"]["count"]) / totalStudents) * 100)
                    .round();

            final value = PieChartSectionData(
                color: data["color"],
                value: double.parse(data["value"]["count"].toString()),
                title: "${percentage}%",
                titleStyle: const TextStyle(
                  fontFamily: "Proxima",
                  color: Colors.white,
                ));

            return MapEntry(key, value);
          })
          .values
          .toList();
    }

    // var larg = findLargest(stats[bachlor]);
    return Scaffold(
      drawer: CustomDrawer(
        index: 1,
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
              }
              isDrawerOpen = false;
            }
          },
          child: statss.length == 0
              ? Center(
                  child: Container(),
                )
              : LiquidPullToRefresh(
                  onRefresh: () async {
                    Provider.of<DataProvider>(context, listen: false)
                        .fetchStats();
                    Provider.of<DataProvider>(context, listen: false)
                        .getApplis();
                  },
                  showChildOpacityTransition: false,
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Statistics",
                              style: TextStyle(
                                fontFamily: "Proxima",
                                fontSize: Platform.isIOS
                                    ? config.App(context).appHeight(4)
                                    : config.App(context).appHeight(4.5),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: Platform.isIOS
                                        ? config.App(context).appHeight(2)
                                        : config.App(context).appHeight(2.5),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    width: double.infinity,
                                    height: Platform.isIOS
                                        ? config.App(context).appHeight(35)
                                        : config.App(context).appHeight(41),
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Total Student Number : ${int.parse(bachApplis[0]["count"]) + int.parse(masterApplis[0]["count"])}",
                                          style: TextStyle(
                                            fontFamily: "Proxima",
                                            fontSize: Platform.isIOS
                                                ? config.App(context)
                                                    .appHeight(2)
                                                : config.App(context)
                                                    .appHeight(2.5),
                                          ),
                                        ),
                                        Text(
                                          "Undergraduate Students : ${bachApplis[0]["count"]}",
                                          style: TextStyle(
                                            fontFamily: "Proxima",
                                            fontSize: Platform.isIOS
                                                ? config.App(context)
                                                    .appHeight(2)
                                                : config.App(context)
                                                    .appHeight(2.5),
                                          ),
                                        ),
                                        Text(
                                          "Masters Students : ${masterApplis[0]["count"]}",
                                          style: TextStyle(
                                            fontFamily: "Proxima",
                                            fontSize: Platform.isIOS
                                                ? config.App(context)
                                                    .appHeight(2)
                                                : config.App(context)
                                                    .appHeight(2.5),
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              config.App(context).appHeight(1),
                                        ),
                                        Expanded(
                                          child: PieChart(
                                            PieChartData(
                                              sections: getSections(
                                                {
                                                  "bachlors": bachApplis[0],
                                                  "masters": masterApplis[0]
                                                },
                                                int.parse(bachApplis[0]
                                                        ["count"]) +
                                                    int.parse(masterApplis[0]
                                                        ["count"]),
                                              ),
                                            ),
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
                                  Text(
                                    "Undergraduate Departments",
                                    style: TextStyle(
                                      fontFamily: "Proxima",
                                      fontSize: Platform.isIOS
                                          ? config.App(context).appHeight(2.5)
                                          : config.App(context).appHeight(3),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Platform.isIOS
                                        ? config.App(context).appHeight(2)
                                        : config.App(context).appHeight(2.5),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    width: double.infinity,
                                    height: Platform.isIOS
                                        ? config.App(context).appHeight(35)
                                        : config.App(context).appHeight(41),
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
                                    child: ListView.builder(
                                      itemCount: bachlorStats.length,
                                      itemBuilder: (context, i) {
                                        if (i == 0) {
                                          return Column(
                                            children: [
                                              DeparmentChart(
                                                larg: int.parse(
                                                    bachApplis[0]["count"]),
                                                title:
                                                    "Total Undergraduate Students",
                                                count: int.parse(
                                                    bachApplis[0]["count"]),
                                                type: 0,
                                              ),
                                              DeparmentChart(
                                                larg: int.parse(
                                                    bachApplis[0]["count"]),
                                                title: bachlorStats[i]
                                                    ["department"],
                                                count: int.parse(
                                                    bachlorStats[i]["count"]),
                                                type: 0,
                                              )
                                            ],
                                          );
                                        }
                                        return DeparmentChart(
                                          larg:
                                              int.parse(bachApplis[0]["count"]),
                                          title: bachlorStats[i]["department"],
                                          count: int.parse(
                                              bachlorStats[i]["count"]),
                                          type: 0,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: Platform.isIOS
                                        ? config.App(context).appHeight(2)
                                        : config.App(context).appHeight(2.5),
                                  ),
                                  Text(
                                    "Graduate Departments",
                                    style: TextStyle(
                                      fontFamily: "Proxima",
                                      fontSize: Platform.isIOS
                                          ? config.App(context).appHeight(2.5)
                                          : config.App(context).appHeight(3),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Platform.isIOS
                                        ? config.App(context).appHeight(2)
                                        : config.App(context).appHeight(2.5),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    width: double.infinity,
                                    height: Platform.isIOS
                                        ? config.App(context).appHeight(35)
                                        : config.App(context).appHeight(41),
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
                                    child: ListView.builder(
                                      itemCount: masterStats.length,
                                      itemBuilder: (context, i) {
                                        if (i == 0) {
                                          return Column(
                                            children: [
                                              DeparmentChart(
                                                larg: int.parse(
                                                    masterApplis[0]["count"]),
                                                title: "Total Masters Students",
                                                count: int.parse(
                                                    masterApplis[0]["count"]),
                                                type: 1,
                                              ),
                                              DeparmentChart(
                                                larg: int.parse(
                                                    masterApplis[0]["count"]),
                                                title: masterStats[i]
                                                    ["department"],
                                                count: int.parse(
                                                    masterStats[i]["count"]),
                                                type: 1,
                                              )
                                            ],
                                          );
                                        }
                                        return DeparmentChart(
                                          larg: int.parse(
                                              masterApplis[0]["count"]),
                                          title: masterStats[i]["department"],
                                          count: int.parse(
                                              masterStats[i]["count"]),
                                          type: 1,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class DeparmentChart extends StatelessWidget {
  const DeparmentChart(
      {Key? key,
      required this.larg,
      required this.title,
      required this.count,
      required this.type})
      : super(key: key);

  final int larg;
  final String title;
  final int count;
  final int type;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: Platform.isIOS
                  ? config.App(context).appHeight(2)
                  : config.App(context).appHeight(2.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey.shade300,
              ),
            ),
            Container(
              width: config.App(context)
                  .appWidth(((count / larg) * 100).round().toDouble() * 2),
              height: Platform.isIOS
                  ? config.App(context).appHeight(2)
                  : config.App(context).appHeight(2.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: this.type == 0 ? Color(0xFF015BAA) : Color(0xFF02AEF1),
              ),
            ),
            Container(
              width: double.infinity,
              height: Platform.isIOS
                  ? config.App(context).appHeight(2)
                  : config.App(context).appHeight(2.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color:
                        this.type == 0 ? Color(0xFF02AEF1) : Color(0xFF015BAA),
                    fontFamily: "Proxima",
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: Platform.isIOS
                    ? config.App(context).appWidth(80)
                    : config.App(context).appWidth(75),
              ),
              child: Text(
                title.toUpperCase().toString(),
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontFamily: "Proxima",
                  fontSize: config.App(context).appHeight(1.5),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: config.App(context).appHeight(1),
        )
      ],
    );
  }
}

class Dep {
  final String name;
  final int count;

  Dep(this.name, this.count);
}
