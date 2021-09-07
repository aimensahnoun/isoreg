import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isoregistration/helpers/app_config.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../helpers/custom_icons_icons.dart';
import '../provider/data_provider.dart';
import '../screens/student_details.dart';
import '../helpers/app_config.dart' as config;
import 'package:string_validator/string_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewProfile extends StatefulWidget {
  const CreateNewProfile({Key? key}) : super(key: key);

  @override
  State<CreateNewProfile> createState() => _CreateNewProfileState();
}

class _CreateNewProfileState extends State<CreateNewProfile> {
  @override
  void didChangeDependencies() {
    returnList(_application);
    super.didChangeDependencies();
  }

  bool isChangeApplication = true;
  bool isSubmitting = false;
  var passportNode = FocusNode();
  var pinCodeNode = FocusNode();
  String fullName = "";
  String passportNumber = "";
  String pinCode = "";

  List<String> returnList(String application) {
    if (application == "Bachlors") {
      bscDep.sort();

      _department = bscDep[0];
      if (isChangeApplication) {
        valueTest = bscDep[0];
      }
      return bscDep;
    }
    mscDep.sort();
    _department = mscDep[0];
    if (isChangeApplication) {
      valueTest = mscDep[0];
    }
    return mscDep;
  }

  List<String> mscDep = [
    "MBA (ENGLISH, THESIS",
    "MBA (ENGLISH, NONTHESIS)",
    "MBA (ENGLISH, THESIS , DE)",
    "MBA (Tr/T-NT-D)",
    "Executive MBA (En/NT)",
    "MARKETING (ENGLISH, NONTHESIS)",
    "MARKETING (ENGLISH, THESIS)",
    "MARKETING (TURKISH, NONTHESIS)",
    "MARKETING (TURKISH, THESIS)",
    "Strategic Marketing and Brand Management (Tr/NT/Goztepe)",
    "Management and Information Systems (Tr/NT)",
    "Supply Chain and Logistic Management (Tr/T-NT)",
    "Human Resources (Tr/T-NT/Goztepe",
    "Human Resources Management (Tr/NT/D)",
    "ENTREPRENEURSHIP AND INNOVATION MANAGEMENT (ENGLISH, NON-THESIS,WEEKEND)",
    "ENTREPRENUERSHIP AND INNOVATION MANAGEMENT (ENGLISH, THESIS, WEEKEND)",
    "CAPITAL MARKETS AND FINANCE (ENGLISH, NONTHESIS)",
    "CAPITAL MARKETS AND FINANCE (ENGLISH, THESIS)",
    "CAPITAL MARKETS AND FINANCE (TURKISH, THESIS)"
        "Accounting and International Reporting (Tr/NT)",
    "Banking and Finance (Tr/T-NT)",
    "FINANCIAL TECHNOLOGY (ENGLISH, THESIS)",
    "FINANCIAL TECHNOLOGY (ENGLISH, NONTHESIS)",
    "Global Politics and International Relations",
    "GLOBAL AFFAIRS (ENGLISH, NON-THESIS, WEEKEND)",
    "GLOBAL AFFAIRS (ENGLISH, THESIS, WEEKEND)",
    "History (Tr/T-NT)",
    "Philosphy (Tr/T)",
    "Infomation Technology Law (Tr/T-NT)",
    "Capital Markets and Commercial Law Tr/T)",
    "Private Law (Tr/T)",
    "Public Law (Tr/T)",
    "Communication Design (En/T)",
    "GAME DESIGN (ENGLISH, THESIS)",
    "GAME DEVELOPMENT TECHNOLOGIES (ENGLISH, NONTHESIS)"
        "Advertising and Brand Communication Management (Tr/T-NT)",
    "Cinema and Television (En/T)",
    "Marketing Communications and Public Relations (Tr/T-NT)",
    "Sports Management (En/T)",
    "EDUCATIONAL TECHNOLOGY (ENGLISH, THESIS)",
    "EDUCATIONAL TECHNOLOGY (TURKISH, THESIS)",
    "EDUCATIONAL TECHNOLOGY (ENGLISH, NONTHESIS)",
    "EDUCATIONAL TECHNOLOGY (TURKISH, NONTHESIS)",
    "Educational Administration and Planning (Tr /T-NT)",
    "ENGLISH LANGUAGE EDUCATION (ENGLISH, NONTHESIS, DE)",
    "ENGLISH LANGUAGE EDUCATION (ENGLISH, THESIS)",
    "ENGLISH LANGUAGE EDUCATION (ENGLISH, NONTHESIS)"
        "EDUCATIONAL DESIGN AND EVALUATION (ENGLISH, THESIS)",
    "EDUCATIONAL DESIGN AND EVALUATION (TURKISH, THESIS)",
    "EDUCATIONAL DESIGN AND EVALUATION (ENGLISH, NONTHESIS)",
    "EDUCATIONAL DESIGN AND EVALUATION (TURKISH, NONTHESIS)",
    "Early Childhood Education (En-Tr /T-NT)",
    "GUIDANCE AND COUNSELING (ENGLISH, THESIS)",
    "GUIDANCE AND COUNSELING (TURKISH, THESIS)",
    "ARTIFICIAL INTELLIGENCE (ENGLISH, NONTHESIS)",
    "ARTIFICIAL INTELLIGENCE (ENGLISH, THESIS)",
    "Instructional Technologies (Tr / NT / D)",
    "INFORMATION TECHNOLOGIES (ENGLISH, THESIS)",
    "INFORMATION TECHNOLOGIES (ENGLISH, NONTHESIS)",
    "INFORMATION TECHNOLOGIES (TURKISH, THESIS)",
    "INFORMATION TECHNOLOGIES (TURKISH, NONTHESIS)",
    "BIG DATA ANALYTICS AND MANAGEMENT (ENGLISH, NONTHESIS)",
    "BIG DATA ANALYTICS AND MANAGEMENT (ENGLISH, THESIS)",
    "COMPUTER ENGINEERING (ENGLISH, THESIS)",
    "MECHATRONICS ENGINEERING (ENGLISH, THESIS)",
    "MECHATRONICS ENGINEERING (ENGLISH, NONTHESIS)",
    "ENGINEERING MANAGEMENT (ENGLISH, NONTHESIS)",
    "ENGINEERING MANAGEMENT (TURKISH, NONTHESIS)",
    "ENGINEERING MANAGEMENT (TURKISH, THESIS)",
    "BIOENGINEERING (ENGLISH, THESIS)",
    "BIOMEDICAL ENGINEERING (ENGLISH, THESIS)",
    "ELECTRIC ELECTRONIC ENGINEERING (ENGLISH, THESIS)",
    "ELECTRIC ELECTRONIC ENGINEERING (ENGLISH, NONTHESIS)"
        "INDUSTRIAL ENGINEERING (ENGLISH, THESIS)",
    "INDUSTRY 4.0 (ENGLISH, NONTHESIS)",
    "INDUSTRY 4.0 (ENGLISH, THESIS)",
    "Sound Technologies (Tr/T-NT)",
    "CYBER SECURITY (ENGLISH, NONTHESIS)",
    "CYBER SECURITY (ENGLISH, THESIS)",
    "ARCHITECTURE (ENGLISH, THESIS)",
    "Interior Design (Tr/T)",
    "Construction Management (Tr/T-NT)",
    "Industrial Design and Innovation Management (Tr/T)",
    "ENERGY SYSTEMS OPERATION AND TECHNOLOGIES (ENGLISH, THESIS)",
    "ENERGY SYSTEMS OPERATION AND TECHNOLOGIES (ENGLISH, NONTHESIS)",
    "NEUROSCIENCE (ENGLISH, THESIS)",
    "Family Councelling (Tr/T-NT)",
    "Nursing (Tr/T)",
    "PHYSIOTHERAPY AND REHABILITATION (TÜRKÇE, TEZLİ)",
    "Osteopathy Manual Therapy (Tr/T)",
    "Health Management (Tr/T-NT)",
    "Chiropractic (Tr/T)",
    "Health Informatics (Tr/T-NT)",
    "Nutrition and Dietics (Tr/T)",
    "Social Work (Tr / NT)",
    "Tissue Engineering and Regenerative Medicine (Tr/T)",
    "Pharmaceutical Medicine (Tr/T)",
    "FILM AND TELEVISION (ENGLISH, THESIS)"
  ];

  List<String> bscDep = [
    "Business Administration",
    "Economics",
    "Economics and Finance",
    "Internation Finance",
    "Internation Trade and Business",
    "Logistic Management",
    "Political Science and International Relations",
    "Psychology ",
    "Sociology",
    "Biomedical Engineering",
    "Civil Engineering",
    "Computer Engineering",
    "Electrical and Electronics Engineering",
    "Energy Systems Engineering",
    "Industrial Engineering",
    "Management Engineering",
    "Mathematics",
    "Mechatronics Engineering",
    "Molecular Biology and Genetics",
    "Software Engineering",
    "ARTIFICIAL INTELLIGENCE ENGINEERING",
    "Computer Education and Instructional Technologies",
    "English Language Teaching",
    "Pre-School Education",
    "Psychological Counseling and Guidance",
    "Law (TR)",
    "Advertising",
    "Cartoon and Animation",
    "Film and Television",
    "Communication Design",
    "Digital Game Design",
    "New Media",
    "Public Relations",
    "Gastronomy",
    "Pilotage",
    "Nursing",
    "Nutrition and Dietetics",
    "Physiotherapy and Rehabilitation",
    "Architecture",
    "Industrail Product Design",
    "Interior Architecture and Enviormental Design",
    "DENTAL MEDICINE",
    "Medicine"
  ];
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  String _application = "Bachlors";
  late String _department = "Android";
  String valueTest = "";
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<DataProvider>(context, listen: false).user;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: isSubmitting,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            CustomIcons.angle_left_b,
                            size: Platform.isIOS
                                ? config.App(context).appHeight(4)
                                : config.App(context).appHeight(4.5),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: Platform.isIOS
                              ? config.App(context).appWidth(5)
                              : config.App(context).appWidth(5.5),
                        ),
                        Text(
                          "New Student Profile",
                          style: TextStyle(
                            fontFamily: "Proxima",
                            fontSize: Platform.isIOS
                                ? config.App(context).appHeight(3)
                                : config.App(context).appHeight(3.5),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Platform.isIOS
                          ? config.App(context).appHeight(1)
                          : config.App(context).appHeight(1.5),
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          children: [
                            Container(
                              child: TextFormField(
                                autocorrect: false,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(passportNode);
                                },
                                onChanged: (value) {
                                  fullName = value;
                                },
                                validator: (value) {
                                  if (value == "") {
                                    return "Please enter your full name";
                                  }
                                  var temp = value.toString().split(" ");
                                  if (temp.length < 2) {
                                    return "Please enter your first and last name";
                                  }
                                },
                                style: const TextStyle(
                                  fontFamily: "Proxima",
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF0054A1)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF0054A1))),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  labelText: "Full Name",
                                  labelStyle: const TextStyle(
                                    fontFamily: "Proxima",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Platform.isIOS
                                  ? config.App(context).appHeight(2)
                                  : config.App(context).appHeight(2.5),
                            ),
                            Container(
                              child: TextFormField(
                                focusNode: passportNode,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(pinCodeNode);
                                },
                                onChanged: (value) {
                                  passportNumber = value;
                                },
                                validator: (value) {
                                  if (value == "") {
                                    return "Please enter your passport number";
                                  }
                                  if (isAlpha(value.toString())) {
                                    return "Please enter a valid passport number";
                                  }
                                },
                                style: const TextStyle(
                                  fontFamily: "Proxima",
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF0054A1)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF0054A1))),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  labelText: "Passport Number",
                                  labelStyle: const TextStyle(
                                    fontFamily: "Proxima",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Platform.isIOS
                                  ? config.App(context).appHeight(2)
                                  : config.App(context).appHeight(2.5),
                            ),
                            Container(
                              child: TextFormField(
                                focusNode: pinCodeNode,
                                onChanged: (value) {
                                  pinCode = value;
                                },
                                validator: (value) {
                                  if (value == "") {
                                    return "Please enter your pin code";
                                  }
                                  if (!isNumeric(value.toString())) {
                                    return "Please enter a valid pin code";
                                  }
                                },
                                style: const TextStyle(
                                  fontFamily: "Proxima",
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF0054A1)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF0054A1))),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  labelText: "Pin Code",
                                  labelStyle: const TextStyle(
                                    fontFamily: "Proxima",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Platform.isIOS
                                  ? config.App(context).appHeight(2)
                                  : config.App(context).appHeight(2.5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Bachelors",
                                      style: TextStyle(
                                        fontFamily: "Proxima",
                                        fontSize: Platform.isIOS
                                            ? config.App(context).appHeight(2)
                                            : config.App(context)
                                                .appHeight(2.5),
                                      ),
                                    ),
                                    Radio(
                                      value: "Bachlors",
                                      groupValue: _application,
                                      onChanged: (value) {
                                        setState(() {
                                          _application = value.toString();
                                          isChangeApplication = true;

                                          returnList(_application);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Masters",
                                      style: TextStyle(
                                          fontFamily: "Proxima",
                                          fontSize: Platform.isIOS
                                              ? config.App(context).appHeight(2)
                                              : config.App(context)
                                                  .appHeight(2.5)),
                                    ),
                                    Radio(
                                        value: "Masters",
                                        groupValue: _application,
                                        onChanged: (value) {
                                          setState(() {
                                            _application = value.toString();
                                            isChangeApplication = true;
                                            returnList(_application);
                                          });
                                        }),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                                height: Platform.isIOS
                                    ? config.App(context).appHeight(2)
                                    : config.App(context).appHeight(2.5)),
                            Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Department :",
                                    style: TextStyle(
                                      fontFamily: "Proxima",
                                    ),
                                  ),
                                  SizedBox(
                                    height: Platform.isIOS
                                        ? config.App(context).appHeight(1)
                                        : config.App(context).appHeight(1.5),
                                  ),
                                  Container(
                                    width: double.infinity,
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: DropdownButton<String>(
                                      borderRadius: BorderRadius.circular(15),
                                      isExpanded: true,
                                      value: _department,
                                      //elevation: 5,
                                      style: TextStyle(color: Colors.black),

                                      items: returnList(_application)
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),

                                      onChanged: (value) {
                                        setState(() {
                                          isChangeApplication = false;
                                          _department = value.toString();
                                          valueTest = value.toString();
                                        });
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
                  ],
                ),
                InkWell(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      try {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var jwt = await prefs.getString("jwt");
                        setState(() => {isSubmitting = true});
                        var uuid = Uuid();
                        var id = uuid.v4();
                        var url =
                            Uri.parse("https://isoreg.herokuapp.com/students");
                        http.Response response = await http.post(
                          url,
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                            "Authorization": "Bearer ${jwt}",
                          },
                          body: jsonEncode(<String, String>{
                            "full_name": fullName,
                            "passport_number": passportNumber,
                            "pin_code": pinCode,
                            "application": _application,
                            "department": valueTest,
                            "uid": id,
                            "id": id,
                            "current_step": 1.toString(),
                            "lower_case_name": fullName.toLowerCase(),
                            "document_check_status": "Documents Not Checked",
                            "decument_check_note": "",
                            "denklik_application_status": "Denklik Not Done",
                            "denklik_note": "",
                            "pin": pinCode,
                            "passport": passportNumber,
                            "name": convertString(fullName),
                          }),
                        );
                        if (response.statusCode == 200) {
                          String data = response.body;
                          var decodedData = jsonDecode(data);
                        }

                        var student = {
                          "full_name": fullName,
                          "passport_number": passportNumber,
                          "pin_code": pinCode,
                          "application": _application,
                          "department": valueTest,
                          "id": id,
                          "current_step": 1,
                          "lower_case_name": fullName.toLowerCase(),
                          "document_check_status": "Documents Not Checked",
                          "decument_check_note": "",
                          "denklik_application_status": "Denklik Not Done",
                          "denklik_note": "",
                        };

                        var url2 =
                            Uri.parse("https://isoreg.herokuapp.com/applis");
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
                          decodedData = jsonDecode(data);
                        } else {}

                        var bachlor = decodedData.firstWhere(
                            (element) => element["slug"] == "bachlors",
                            orElse: () {
                          return null;
                        });

                        var master = decodedData.firstWhere(
                            (element) => element["slug"] == "masters",
                            orElse: () {
                          return null;
                        });

                        var depart = await http.get(
                          Uri.parse(
                              "https://isoreg.herokuapp.com/stats/${convertString(valueTest)}"),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                            "Authorization": "Bearer ${jwt}",
                          },
                        );

                        if (depart.statusCode == 404) {
                          await http.post(
                            Uri.parse("https://isoreg.herokuapp.com/stats"),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                              "Authorization": "Bearer ${jwt}",
                            },
                            body: jsonEncode(<String, String>{
                              "department": valueTest,
                              "type": _application,
                              "count": 1.toString(),
                              "dep": convertString(valueTest),
                            }),
                          );
                        } else {
                          await http.put(
                              Uri.parse(
                                  "https://isoreg.herokuapp.com/stats/update/${convertString(valueTest)}"),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                "Authorization": "Bearer ${jwt}",
                              },
                              body: jsonEncode({
                                "count": (int.parse(
                                            jsonDecode(depart.body)["count"]) +
                                        1)
                                    .toString()
                              }));
                        }

                        if (_application == "Bachlors") {
                          await http.put(
                              Uri.parse(
                                  "https://isoreg.herokuapp.com/applis/bachlors"),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                "Authorization": "Bearer ${jwt}",
                              },
                              body: jsonEncode({
                                "count":
                                    (int.parse(bachlor["count"]) + 1).toString()
                              }));
                        } else {
                          await http.put(
                              Uri.parse(
                                  "https://isoreg.herokuapp.com/applis/masters"),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                "Authorization": "Bearer ${jwt}",
                              },
                              body: jsonEncode({
                                "count":
                                    (int.parse(master["count"]) + 1).toString()
                              }));
                        }

                        DateTime now = new DateTime.now();
                        DateTime date = new DateTime(
                            now.year, now.month, now.day, now.hour, now.minute);

                        await http.post(
                            Uri.parse("https://isoreg.herokuapp.com/tracks"),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                              "Authorization": "Bearer ${jwt}",
                            },
                            body: jsonEncode({
                              "message":
                                  "${userData["name"]} created a profile for student : ${pinCode}",
                              "time": date.toString(),
                            }));

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext ctx) => StudentDetails(
                                  student: student,
                                )));
                      } catch (error) {
                        print(error);
                      }
                    }
                    setState(() => {isSubmitting = false});
                  },
                  child: Container(
                    width: Platform.isIOS
                        ? config.App(context).appWidth(50)
                        : config.App(context).appWidth(55),
                    height: Platform.isIOS
                        ? config.App(context).appHeight(8)
                        : config.App(context).appHeight(9),
                    decoration: BoxDecoration(
                      color: Color(0xFF0054A1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                            fontFamily: "Proxima",
                            color: Colors.white,
                            fontSize: Platform.isIOS
                                ? config.App(context).appHeight(3.5)
                                : config.App(context).appHeight(4)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
