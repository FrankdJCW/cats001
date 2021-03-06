import 'dart:async';

import 'package:cats001/widgets/header.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffolkey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  String username = "";

  submit() {
    final form = _formkey.currentState;
    if (form!.validate()) {
      SnackBar snackBar = SnackBar(content: Text("Welcome to FIU Animals"));
      form.save();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context, username);
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffolkey,
      appBar:
          header(context, titleText: "Create account", removeBackButton: true),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      "Create a username",
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                        key: _formkey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          validator: (val) {
                            if (val!.trim().length < 3 || val.isEmpty) {
                              return "Username too short";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (val) => username = val!,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Username",
                            labelStyle: TextStyle(fontSize: 15.0),
                            hintText: "Must be at least 3 characters",
                          ),
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () => submit(),
                  child: Container(
                      height: 50.0,
                      width: 350.0,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(7.0)),
                      child: Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
