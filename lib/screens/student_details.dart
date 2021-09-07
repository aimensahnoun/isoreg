import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../helpers/custom_icons_icons.dart';
import '../provider/data_provider.dart';
import '../screens/student_list.dart';
import "../helpers/app_config.dart" as config;
import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:io' show Platform;

class StudentDetails extends StatefulWidget {
  late var student;
  StudentDetails({this.student});

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  @override
  var stepsBsc = {
    "1": "Deposit Payment",
    "2": "Document Check",
    "3": "Tuition Fees Payment",
    "4": "Final Acceptance Letter",
    "5": "Denklik Application",
    "6": "Registration"
  };

  var stepsMsc = {
    "1": "Deposit Payment",
    "2": "Document Check",
    "3": "Tuition Fees Payment",
    "4": "Final Acceptance Letter",
    "5": "Registration"
  };

  bool isLoading = false;

  int _index = 0;
  bool canMove = true;
  var docCheckValue = "Documents Not Checked";
  var denklilValue = "Denklik Not Done";
  var docCheckNote = "";
  var denklinkNote = "";

  @override
  void didChangeDependencies() {
    if ((widget.student["current_step"] != 74)) {
      _index = int.parse(widget.student["current_step"]) - 1;
      docCheckValue = widget.student["document_check_status"];
      denklilValue = widget.student["denklik_application_status"];
    } else {
      if (widget.student["application"] == "Bachlors") {
        _index = 5;
      } else {
        _index = 4;
      }
    }

    super.didChangeDependencies();
  }

  showCongrats() {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Registration Complete',
      btnOkOnPress: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    ).show();
  }

  void go(int index) async {
    if (index == -1 && _index <= 0) {
      return;
    }

    if (index == 1 && _index >= 6) {
      return;
    }

    if (widget.student["current_step"] == 74) {
      return;
    }

    setState(() {
      _index += index;
    });
  }

  Widget build(BuildContext context) {
    var userData = Provider.of<DataProvider>(context, listen: false).user;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 45, left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            CustomIcons.angle_left_b,
                            color: Colors.black,
                            size: Platform.isIOS
                                ? config.App(context).appHeight(4)
                                : config.App(context).appHeight(4.5),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                        ),
                        SizedBox(
                          width: config.App(context).appWidth(14),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: Platform.isIOS
                                ? config.App(context).appWidth(65)
                                : config.App(context).appWidth(60),
                          ),
                          child: Hero(
                            tag: widget.student["pin_code"],
                            child: Text(
                              widget.student["full_name"].toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Proxima",
                                fontSize: Platform.isIOS
                                    ? config.App(context).appHeight(2)
                                    : config.App(context).appHeight(2.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: Platform.isIOS
                                  ? config.App(context).appWidth(90)
                                  : config.App(context).appWidth(85),
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Passport No:",
                                          style: TextStyle(
                                            fontFamily: "Proxima",
                                            fontSize: Platform.isIOS
                                                ? config.App(context)
                                                    .appHeight(1.7)
                                                : config.App(context)
                                                    .appHeight(2),
                                          ),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: Platform.isIOS
                                                ? config.App(context)
                                                    .appWidth(45)
                                                : config.App(context)
                                                    .appWidth(40),
                                          ),
                                          child: Text(
                                            widget.student["passport_number"],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily: "Proxima",
                                              fontSize: Platform.isIOS
                                                  ? config.App(context)
                                                      .appHeight(1.7)
                                                  : config.App(context)
                                                      .appHeight(2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    widget.student["application"] == "Bachlors"
                                        ? "BSc"
                                        : "MSc",
                                    style: TextStyle(
                                      fontFamily: "Proxima",
                                      fontSize: Platform.isIOS
                                          ? config.App(context).appHeight(2)
                                          : config.App(context).appHeight(2.5),
                                      color: widget.student["application"] ==
                                              "Bachlors"
                                          ? Color(0xFF0054A1)
                                          : Color(0xFF019EE2),
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: config.App(context).appHeight(1),
                          ),
                          Row(
                            children: [
                              Text(
                                "Pin Code:",
                                style: TextStyle(
                                  fontFamily: "Proxima",
                                  fontSize: Platform.isIOS
                                      ? config.App(context).appHeight(1.7)
                                      : config.App(context).appHeight(2),
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: Platform.isIOS
                                      ? config.App(context).appWidth(20)
                                      : config.App(context).appWidth(15),
                                ),
                                child: Text(
                                  widget.student["pin_code"],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: "Proxima",
                                    fontSize: Platform.isIOS
                                        ? config.App(context).appHeight(1.7)
                                        : config.App(context).appHeight(2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: config.App(context).appHeight(1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  Text(
                                    "Department : ",
                                    style: TextStyle(
                                      fontFamily: "Proxima",
                                      fontSize: Platform.isIOS
                                          ? config.App(context).appHeight(1.7)
                                          : config.App(context).appHeight(2),
                                    ),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: Platform.isIOS
                                          ? config.App(context).appWidth(55)
                                          : config.App(context).appWidth(45),
                                    ),
                                    child: Text(
                                      widget.student["department"],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: TextStyle(
                                        fontFamily: "Proxima",
                                        fontSize: Platform.isIOS
                                            ? config.App(context).appHeight(1.6)
                                            : config.App(context)
                                                .appHeight(1.9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: config.App(context).appHeight(1),
                          ),
                          Row(
                            children: [
                              Text(
                                "Status: ",
                                style: TextStyle(
                                  fontFamily: "Proxima",
                                  fontSize: Platform.isIOS
                                      ? config.App(context).appHeight(1.8)
                                      : config.App(context).appHeight(2.1),
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: Platform.isIOS
                                      ? config.App(context).appWidth(55)
                                      : config.App(context).appWidth(50),
                                ),
                                child: Text(
                                  widget.student["current_step"] == 74
                                      ? "Registration Complete"
                                      : (widget.student["application"] ==
                                              "Bachlors"
                                          ? stepsBsc[widget
                                                  .student["current_step"]]
                                              .toString()
                                          : stepsMsc[widget
                                                  .student["current_step"]]
                                              .toString()),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                      fontFamily: "Proxima",
                                      fontSize: Platform.isIOS
                                          ? config.App(context).appHeight(1.8)
                                          : config.App(context).appHeight(2.1),
                                      color:
                                          widget.student["current_step"] == 74
                                              ? Color(0xFF177247)
                                              : Colors.orange),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: config.App(context).appHeight(1),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: EnhanceStepper(
                type: StepperType.vertical,
                currentStep: _index,
                steps: widget.student["application"] == "Bachlors"
                    ? [
                        EnhanceStep(
                          isActive: _index > 0 ? true : false,
                          title: Text(
                            "Deposit Payment",
                            style: TextStyle(fontFamily: "Proxima"),
                          ),
                          content: Container(),
                        ),
                        EnhanceStep(
                          isActive: _index > 1 ? true : false,
                          title: Text(
                            "Document Check",
                            style: TextStyle(fontFamily: "Proxima"),
                          ),
                          content: Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: config.App(context).appWidth(50),
                                  child: DropdownButton(
                                    value: docCheckValue,
                                    elevation: 16,
                                    style: const TextStyle(
                                        fontFamily: "Proxima",
                                        color: Colors.black),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.black,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        docCheckValue = newValue!;
                                      });
                                    },
                                    isExpanded: true,
                                    items: <String>[
                                      'Documents Not Checked',
                                      'Missing Documents',
                                      'Missings Stamps',
                                      'Documents Checked'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                TextField(
                                  onChanged: (text) {
                                    docCheckNote = text;
                                  },
                                  controller: TextEditingController()
                                    ..text =
                                        widget.student["decument_check_note"] ??
                                            "",
                                  style: const TextStyle(
                                    fontFamily: "Proxima",
                                  ),
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: Colors.black)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hintText: "Notes",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        EnhanceStep(
                          isActive: _index > 2 ? true : false,
                          title: Text(
                            "Tuition Fees Payment",
                            style: TextStyle(fontFamily: "Proxima"),
                          ),
                          content: Container(),
                        ),
                        EnhanceStep(
                          isActive: _index > 3 ? true : false,
                          title: Text(
                            "Final Acceptance Letter",
                            style: TextStyle(fontFamily: "Proxima"),
                          ),
                          content: Container(),
                        ),
                        EnhanceStep(
                          isActive: _index > 4 ? true : false,
                          title: Text(
                            "Denklik Application",
                            style: TextStyle(fontFamily: "Proxima"),
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: config.App(context).appWidth(50),
                                child: DropdownButton(
                                  value: denklilValue,
                                  elevation: 16,
                                  style: const TextStyle(
                                      fontFamily: "Proxima",
                                      color: Colors.black),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.black,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      denklilValue = newValue!;
                                    });
                                  },
                                  isExpanded: true,
                                  items: <String>[
                                    'Denklik Not Done',
                                    'No Appointments',
                                    'Denklik Done',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              TextField(
                                onChanged: (text) {
                                  denklinkNote = text;
                                },
                                autocorrect: false,
                                controller: TextEditingController()
                                  ..text = widget.student["denklik_note"],
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
                                      borderSide: const BorderSide(
                                          color: Colors.black)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  hintText: "Notes",
                                ),
                              ),
                            ],
                          ),
                        ),
                        EnhanceStep(
                          isActive: (_index > 5 ||
                                  widget.student["current_step"] == 74)
                              ? true
                              : false,
                          title: Text(
                            "Registration",
                            style: TextStyle(fontFamily: "Proxima"),
                          ),
                          content: Container(),
                        ),
                      ]
                    : [
                        EnhanceStep(
                          isActive: _index > 0 ? true : false,
                          title: Text(
                            "Deposit Payment",
                            style: TextStyle(fontFamily: "Proxima"),
                          ),
                          content: Container(),
                        ),
                        EnhanceStep(
                          isActive: _index > 1 ? true : false,
                          title: Text(
                            "Document Check",
                            style: TextStyle(fontFamily: "Proxima"),
                          ),
                          content: Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: config.App(context).appWidth(50),
                                  child: DropdownButton(
                                    value: docCheckValue,
                                    elevation: 16,
                                    style: const TextStyle(
                                        fontFamily: "Proxima",
                                        color: Colors.black),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.black,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        docCheckValue = newValue!;
                                      });
                                    },
                                    isExpanded: true,
                                    items: <String>[
                                      'Documents Not Checked',
                                      'Missing Documents',
                                      'Missings Stamps',
                                      'Documents Checked'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                TextField(
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
                                        borderSide: const BorderSide(
                                            color: Colors.black)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hintText: "Notes",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        EnhanceStep(
                          isActive: _index > 2 ? true : false,
                          title: Text(
                            "Tuition Fees Payment",
                            style: TextStyle(fontFamily: "Proxima"),
                          ),
                          content: Container(),
                        ),
                        EnhanceStep(
                          isActive: _index > 3 ? true : false,
                          title: Text(
                            "Final Acceptance Letter",
                            style: TextStyle(fontFamily: "Proxima"),
                          ),
                          content: Container(),
                        ),
                        EnhanceStep(
                          isActive: (_index > 4 ||
                                  widget.student["current_step"] == 74)
                              ? true
                              : false,
                          title: Text(
                            "Registration",
                            style: TextStyle(fontFamily: "Proxima"),
                          ),
                          content: Container(),
                        ),
                      ],
                onStepCancel: () {
                  go(-1);
                },
                onStepContinue: () {
                  go(1);
                },
                onStepTapped: (index) {
                  setState(() {
                    _index = index;
                  });
                },
                controlsBuilder: (BuildContext context,
                    {VoidCallback? onStepContinue,
                    VoidCallback? onStepCancel}) {
                  return Row(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_index + 1 != widget.student["current_step"] ||
                              _index == 0) {
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await FirebaseFirestore.instance
                                .collection("students")
                                .doc(widget.student["id"])
                                .set({
                              ...widget.student,
                              "current_step": widget.student["current_step"] - 1
                            });
                            widget.student["current_step"] -= 1;
                          } catch (e) {
                            print(e);
                          }
                          setState(() {
                            isLoading = false;
                          });
                          onStepCancel!();
                        },
                        child: Text("Back"),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_index + 1 != widget.student["current_step"]) {
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });

                          if ((_index == 1 &&
                                  docCheckValue != "Documents Checked") ||
                              (widget.student["application"] == "Bachlors" &&
                                  _index == 4 &&
                                  denklilValue != "Denklik Done")) {
                            try {
                              await FirebaseFirestore.instance
                                  .collection("students")
                                  .doc(widget.student["id"])
                                  .set({
                                ...widget.student,
                                "document_check_status": _index == 1
                                    ? docCheckValue
                                    : widget.student["document_check_status"],
                                "decument_check_note": docCheckNote !=
                                        widget.student["decument_check_note"]
                                    ? docCheckNote
                                    : widget.student["decument_check_note"],
                                "denklik_application_status": _index == 4
                                    ? denklilValue
                                    : widget
                                        .student["denklik_application_status"],
                                "denklik_note": denklinkNote !=
                                        widget.student["denklik_note"]
                                    ? denklinkNote
                                    : widget.student["denklik_note"],
                              });
                              //Document Check status log
                              if (_index == 1 &&
                                  (widget.student["document_check_status"] !=
                                      docCheckValue)) {
                                DateTime now = new DateTime.now();
                                DateTime date = new DateTime(now.year,
                                    now.month, now.day, now.hour, now.minute);
                                await FirebaseFirestore.instance
                                    .collection("logs")
                                    .add({
                                  "message":
                                      "${userData["name"]} updated the document check status to ${docCheckValue} for student : ${widget.student["pin_code"]}",
                                  "time": date.toString(),
                                });
                              }

                              //Document Check Note log
                              if (docCheckNote !=
                                  widget.student["decument_check_note"]) {
                                DateTime now = new DateTime.now();
                                DateTime date = new DateTime(now.year,
                                    now.month, now.day, now.hour, now.minute);
                                await FirebaseFirestore.instance
                                    .collection("logs")
                                    .add({
                                  "message":
                                      "${userData["name"]} updated the document check note to ${docCheckNote} for student : ${widget.student["pin_code"]}"
                                });
                              }
                              //Denklik Note Log
                              if (denklinkNote !=
                                  widget.student["denklik_note"]) {
                                DateTime now = new DateTime.now();
                                DateTime date = new DateTime(now.year,
                                    now.month, now.day, now.hour, now.minute);
                                await FirebaseFirestore.instance
                                    .collection("logs")
                                    .add({
                                  "message":
                                      "${userData["name"]} updated the denklik application status to ${denklilValue} for student : ${widget.student["pin_code"]}",
                                  "time": date.toString(),
                                });
                              }
                              //Denklik step log
                              if (_index == 4 &&
                                  (widget.student[
                                          "denklik_application_status"] !=
                                      denklilValue)) {
                                DateTime now = new DateTime.now();
                                DateTime date = new DateTime(now.year,
                                    now.month, now.day, now.hour, now.minute);
                                await FirebaseFirestore.instance
                                    .collection("logs")
                                    .add({
                                  "message":
                                      "${userData["name"]} updated the denklik application status to ${denklilValue} for student : ${widget.student["pin_code"]}",
                                  "time": date.toString(),
                                });
                              }

                              widget.student["denklik_note"] =
                                  denklinkNote != widget.student["denklik_note"]
                                      ? denklinkNote
                                      : widget.student["denklik_note"];
                              widget.student["decument_check_note"] =
                                  docCheckNote !=
                                          widget.student["decument_check_note"]
                                      ? docCheckNote
                                      : widget.student["decument_check_note"];
                            } catch (e) {
                              print(e);
                            }
                            canMove = false;
                          } else {
                            canMove = true;
                          }

                          if (canMove) {
                            try {
                              await FirebaseFirestore.instance
                                  .collection("students")
                                  .doc(widget.student["id"])
                                  .set({
                                ...widget.student,
                                "current_step":
                                    widget.student["current_step"] + 1,
                                "document_check_status": _index == 1
                                    ? docCheckValue
                                    : widget.student["document_check_status"],
                                "decument_check_note": docCheckNote !=
                                        widget.student["decument_check_note"]
                                    ? docCheckNote
                                    : widget.student["decument_check_note"],
                                "denklik_application_status": _index == 4
                                    ? denklilValue
                                    : widget
                                        .student["denklik_application_status"],
                                "denklik_note": denklinkNote !=
                                        widget.student["denklik_note"]
                                    ? denklinkNote
                                    : widget.student["denklik_note"],
                              });

                              if ((_index != 5 &&
                                      widget.student["application"] ==
                                          "Bachlors") ||
                                  (_index != 4 &&
                                      widget.student["application"] ==
                                          "Masters")) {
                                DateTime now = new DateTime.now();
                                DateTime date = new DateTime(now.year,
                                    now.month, now.day, now.hour, now.minute);
                                await FirebaseFirestore.instance
                                    .collection("logs")
                                    .add({
                                  "message":
                                      "${userData["name"]} moved the student ${widget.student["pin_code"]} to ${widget.student["application"] == "Bachlors" ? stepsBsc[widget.student["current_step"] + 1] : stepsMsc[widget.student["current_step"] + 1]}",
                                  "time": date.toString(),
                                });
                              }

                              widget.student["denklik_note"] =
                                  denklinkNote != widget.student["denklik_note"]
                                      ? denklinkNote
                                      : widget.student["denklik_note"];
                              widget.student["decument_check_note"] =
                                  docCheckNote !=
                                          widget.student["decument_check_note"]
                                      ? docCheckNote
                                      : widget.student["decument_check_note"];
                              widget.student["current_step"] += 1;
                            } catch (e) {
                              print(e);
                            }
                          }

                          if ((_index == 5 &&
                                  widget.student["application"] ==
                                      "Bachlors") ||
                              (_index == 4 &&
                                  widget.student["application"] == "Masters")) {
                            try {
                              await FirebaseFirestore.instance
                                  .collection("students")
                                  .doc(widget.student["id"])
                                  .set({
                                ...widget.student,
                                "current_step": 74,
                              });

                              widget.student["current_step"] = 74;
                              DateTime now = new DateTime.now();
                              DateTime date = new DateTime(now.year, now.month,
                                  now.day, now.hour, now.minute);
                              await FirebaseFirestore.instance
                                  .collection("logs")
                                  .add({
                                "message":
                                    "${userData["name"]} finished student: ${widget.student["pin_code"]} 's registration",
                                "time": date.toString(),
                              });
                              showCongrats();
                            } catch (e) {
                              print(e);
                            }
                          }

                          setState(() {
                            isLoading = false;
                          });
                          if (canMove) {
                            onStepContinue!();
                          }
                        },
                        child: Text("Next"),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
