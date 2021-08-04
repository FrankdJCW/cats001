import 'package:flutter/material.dart';

header(context, {bool isAppTitle = false, String titleText = ''}) {
  return AppBar(
    title: Text(isAppTitle ? "FIU Animals" : titleText,
        style: TextStyle(
            color: Colors.white,
            fontFamily: isAppTitle ? "Signatra" : "",
            fontSize: isAppTitle ? 50.0 : 22.0)),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
