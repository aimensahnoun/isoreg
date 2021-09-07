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

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
                              var student = "";
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              var jwt = await prefs.getString("jwt");

                              if (isNumeric(searchText)) {
                                var tempStudent = await http.get(
                                  Uri.parse(
                                      "https://isoreg.herokuapp.com/students/pin/${searchText}"),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                    "Authorization": "Bearer ${jwt}",
                                  },
                                );

                                if (tempStudent.statusCode == 200) {
                                  String data = await tempStudent.body;
                                  var decodedData = jsonDecode(data);

                                  student = decodedData;
                                } else {
                                  print(tempStudent.body);
                                }

                                if (tempStudent.statusCode == 404) {
                                  tempStudent = await http.get(
                                    Uri.parse(
                                        "https://isoreg.herokuapp.com/students/passport/${searchText}"),
                                    headers: <String, String>{
                                      'Content-Type':
                                          'application/json; charset=UTF-8',
                                      "Authorization": "Bearer ${jwt}",
                                    },
                                  );

                                  if (tempStudent.statusCode == 200) {
                                    String data = await tempStudent.body;
                                    var decodedData = jsonDecode(data);

                                    student = decodedData;
                                  } else {
                                    print(tempStudent.body);
                                  }
                                }
                              } else if (isAlphanumeric(searchText)) {
                                var tempStudent = await http.get(
                                  Uri.parse(
                                      "https://isoreg.herokuapp.com/students/passport/${searchText}"),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                    "Authorization": "Bearer ${jwt}",
                                  },
                                );

                                if (tempStudent.statusCode == 200) {
                                  String data = await tempStudent.body;
                                  var decodedData = jsonDecode(data);
                                  student = decodedData;
                                } else {
                                  print(tempStudent.body);
                                }
                              } else {
                                var tempStudent = await http.get(
                                  Uri.parse(
                                      "https://isoreg.herokuapp.com/students/name/${config.convertString(searchText)}"),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                    "Authorization": "Bearer ${jwt}",
                                  },
                                );

                                if (tempStudent.statusCode == 200) {
                                  String data = await tempStudent.body;
                                  var decodedData = jsonDecode(data);

                                  student = decodedData;
                                } else {
                                  print(tempStudent.body);
                                }
                              }
                              result = student == "" ? null : student;

                              setState(() {
                                result = student == "" ? null : student;
                                ;
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
                            var student;
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var jwt = await prefs.getString("jwt");

                            if (isNumeric(searchText)) {
                              var tempStudent = await http.get(
                                Uri.parse(
                                    "https://isoreg.herokuapp.com/students/pin/${searchText}"),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  "Authorization": "Bearer ${jwt}",
                                },
                              );

                              if (tempStudent.statusCode == 200) {
                                String data = await tempStudent.body;
                                var decodedData = jsonDecode(data);

                                student = decodedData;
                              } else {
                                print(tempStudent.body);
                              }

                              if (tempStudent.statusCode == 404) {
                                tempStudent = await http.get(
                                  Uri.parse(
                                      "https://isoreg.herokuapp.com/students/passport/${searchText}"),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                    "Authorization": "Bearer ${jwt}",
                                  },
                                );

                                if (tempStudent.statusCode == 200) {
                                  String data = await tempStudent.body;
                                  var decodedData = jsonDecode(data);

                                  student = decodedData;
                                } else {
                                  print(tempStudent.body);
                                }
                              }
                            } else if (isAlphanumeric(searchText)) {
                              var tempStudent = await http.get(
                                Uri.parse(
                                    "https://isoreg.herokuapp.com/students/passport/${searchText}"),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  "Authorization": "Bearer ${jwt}",
                                },
                              );

                              if (tempStudent.statusCode == 200) {
                                String data = await tempStudent.body;
                                var decodedData = jsonDecode(data);
                                print(student);
                                student = decodedData;
                              } else {
                                print(tempStudent.body);
                              }
                            } else {
                              var tempStudent = await http.get(
                                Uri.parse(
                                    "https://isoreg.herokuapp.com/students/name/${config.convertString(searchText)}"),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  "Authorization": "Bearer ${jwt}",
                                },
                              );

                              if (tempStudent.statusCode == 200) {
                                String data = await tempStudent.body;
                                var decodedData = jsonDecode(data);

                                student = decodedData;
                              } else {
                                print(tempStudent.body);
                              }
                            }
                            result = student == "" ? null : student;
                            ;

                            setState(() {
                              result = student == "" ? null : student;
                              ;
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
                  ? (result == null || result.length == 0
                      ? Expanded(
                          child: Center(
                            child: Text(
                              "No student found",
                              style: TextStyle(
                                  fontFamily: "Proxima",
                                  fontSize: config.App(context).appHeight(3)),
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: config.App(context).appHeight(1),
                            ),
                            Container(
                              width: double.infinity,
                              child: StudentCard(student: result),
                            ),
                          ],
                        ))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
