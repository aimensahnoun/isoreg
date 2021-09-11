import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/custom_icons_icons.dart';
import '../provider/data_provider.dart';
import '../widgets/student_card.dart';
import "../helpers/app_config.dart" as config;
import 'package:string_validator/string_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

class LogSearch extends StatefulWidget {
  const LogSearch({required this.logs});
  final List logs;

  @override
  State<LogSearch> createState() => _LogSearchState();
}

class _LogSearchState extends State<LogSearch> {
  bool isSearching = false;
  bool isSearchDone = false;
  var result = null;

  @override
  Widget build(BuildContext context) {
    String searchText = "";
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isSearching,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            CustomIcons.angle_left_b,
                            color: Colors.black,
                            size: config.App(context).appHeight(4),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: config.App(context).appWidth(20),
                        ),
                        Text(
                          "Search",
                          style: TextStyle(
                            fontFamily: "Proxima",
                            fontSize: config.App(context).appHeight(4),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: config.App(context).appHeight(2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: config.App(context).appWidth(75),
                          child: TextField(
                            autocorrect: false,
                            onSubmitted: (_) async {
                              setState(() {
                                isSearching = true;
                              });

                              result = widget.logs
                                  .where((e) => e["message"]
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()))
                                  .toList();
                              setState(() {
                                isSearching = false;
                                isSearchDone = true;
                              });
                            },
                            onChanged: (value) {
                              searchText = value;
                            },
                            style: const TextStyle(
                              fontFamily: "Proxima",
                            ),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      const BorderSide(color: Colors.black)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Search For Student",
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            CustomIcons.search,
                            color: Colors.black,
                            size: config.App(context).appHeight(4),
                          ),
                          onPressed: () async {
                            setState(() {
                              isSearching = true;
                            });
                            setState(() {
                              isSearching = true;
                            });

                            result = widget.logs
                                .where((e) => e["message"]
                                    .toLowerCase()
                                    .contains(searchText.toLowerCase()))
                                .toList();
                            setState(() {
                              isSearching = false;
                              isSearchDone = true;
                            });
                            setState(() {
                              isSearching = false;
                              isSearchDone = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              isSearchDone
                  ? (result == null || result!.length == 0
                      ? Expanded(
                          child: Center(
                            child: Text(
                              "No logs found",
                              style: TextStyle(
                                  fontFamily: "Proxima",
                                  fontSize: config.App(context).appHeight(3)),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              itemCount: result.length,
                              itemBuilder: (BuildContext ctx, i) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Container(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Message : ${result[i]["message"]}",
                                              style: TextStyle(
                                                fontSize: Platform.isIOS
                                                    ? config.App(context)
                                                        .appHeight(2)
                                                    : config.App(context)
                                                        .appHeight(2.5),
                                                fontFamily: "Proxima",
                                              ),
                                            ),
                                            SizedBox(
                                                height: Platform.isIOS
                                                    ? config.App(context)
                                                        .appHeight(2)
                                                    : config.App(context)
                                                        .appHeight(2.5)),
                                            Text(
                                              "Time : ${result[i]["time"]}",
                                              style: TextStyle(
                                                fontSize: Platform.isIOS
                                                    ? config.App(context)
                                                        .appHeight(2)
                                                    : config.App(context)
                                                        .appHeight(2.5),
                                                fontFamily: "Proxima",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
