import 'package:flutter/material.dart';
import 'package:isoregistration/provider/data_provider.dart';
import 'package:string_validator/string_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "../helpers/app_config.dart" as config;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:provider/provider.dart";

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

GlobalKey<FormState> formKey = new GlobalKey<FormState>();
var passwordNode = FocusNode();

class _LoginScreenState extends State<LoginScreen> {
  @override
  String email = "";
  String password = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Connect To Your Account",
              style: TextStyle(
                fontFamily: "Proxima",
                fontSize: config.App(context).appHeight(3),
              ),
            ),
            SizedBox(height: config.App(context).appHeight(2)),
            Form(
              key: formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: TextFormField(
                        autocorrect: false,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(passwordNode);
                        },
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (value == "") {
                            return ("Please enter a valid email");
                          }

                          if (!isEmail(value.toString())) {
                            return ("Please enter a valid email");
                          }
                          if (!value.toString().contains("bahcesehir")) {
                            return "Please use the university's email";
                          }
                        },
                        style: const TextStyle(
                          fontFamily: "Proxima",
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFF0054A1)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Color(0xFF0054A1))),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: "University Email",
                          labelStyle: const TextStyle(
                            fontFamily: "Proxima",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: config.App(context).appHeight(2),
                    ),
                    Container(
                      child: TextFormField(
                        obscureText: true,
                        focusNode: passwordNode,
                        autocorrect: false,
                        onChanged: (value) {
                          password = value;
                        },
                        validator: (value) {
                          if (value == "") {
                            return "Password needs to be at least 6 characters";
                          }
                        },
                        style: const TextStyle(
                          fontFamily: "Proxima",
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xFF0054A1)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Color(0xFF0054A1))),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: "Password",
                          labelStyle: const TextStyle(
                            fontFamily: "Proxima",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: config.App(context).appHeight(5),
            ),
            Container(
              height: config.App(context).appHeight(7),
              width: config.App(context).appWidth(30),
              decoration: BoxDecoration(
                color: Color(0xFF005AAB),
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    try {
                      var dataProvider =
                          Provider.of<DataProvider>(context, listen: false);
                      var user = await auth.signInWithEmailAndPassword(
                          email: this.email, password: this.password);

                      if (user != null) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setString('pass', this.password);

                        dataProvider.strapiLogin(this.email, this.password);
                        dataProvider.getUserData(email);
                      }
                    } catch (error) {
                      print(error);
                    }
                  }
                },
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: "Proxima",
                      color: Colors.white,
                      fontSize: config.App(context).appHeight(3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
