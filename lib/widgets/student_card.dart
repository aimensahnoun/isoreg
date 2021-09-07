import 'package:flutter/material.dart';
import '../screens/student_details.dart';
import '../helpers/app_config.dart' as config;
import 'dart:io' show Platform;

class StudentCard extends StatelessWidget {
  late var student;

  StudentCard({
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
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

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext ctx) => StudentDetails(student: student),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: double.infinity,
        height: Platform.isIOS
            ? config.App(context).appHeight(18)
            : config.App(context).appHeight(21),
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
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 8.0, // gap between adjacent chips
          runSpacing: 4.0,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Hero(
                              tag: student["pin_code"],
                              child: Text(
                                student["full_name"].toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: "Proxima",
                                  fontSize: Platform.isIOS
                                      ? config.App(context).appHeight(2.5)
                                      : config.App(context).appHeight(3),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            student["application"] == "Bachlors"
                                ? "BSc"
                                : "MSc",
                            style: TextStyle(
                              fontFamily: "Proxima",
                              fontSize: Platform.isIOS
                                  ? config.App(context).appHeight(2)
                                  : config.App(context).appHeight(2.5),
                              color: student["application"] == "Bachlors"
                                  ? Color(0xFF0054A1)
                                  : Color(0xFF019EE2),
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: Platform.isIOS
                        ? config.App(context).appHeight(1)
                        : config.App(context).appHeight(1.5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            "Passport No:",
                            style: TextStyle(
                                fontFamily: "Proxima",
                                fontSize: Platform.isIOS
                                    ? config.App(context).appHeight(1.7)
                                    : config.App(context).appHeight(2)),
                          ),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: Platform.isIOS
                                  ? config.App(context).appWidth(15)
                                  : config.App(context).appWidth(10),
                            ),
                            child: Text(
                              student["passport_number"],
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
                              student["pin_code"],
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
                      )
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
                                  : config.App(context).appWidth(50),
                            ),
                            child: Text(
                              student["department"],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                              style: TextStyle(
                                fontFamily: "Proxima",
                                fontSize: Platform.isIOS
                                    ? config.App(context).appHeight(1.6)
                                    : config.App(context).appHeight(1.9),
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
                          int.parse(student["current_step"]) == 74
                              ? "Registration Complete"
                              : (student["application"] == "Bachlors"
                                  ? stepsBsc[student["current_step"]].toString()
                                  : stepsMsc[student["current_step"]]
                                      .toString()),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                              fontFamily: "Proxima",
                              fontSize: Platform.isIOS
                                  ? config.App(context).appHeight(1.8)
                                  : config.App(context).appHeight(2.1),
                              color: student["current_step"] == 74
                                  ? Color(0xFF177247)
                                  : Colors.orange),
                        ),
                      ),
                    ],
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
