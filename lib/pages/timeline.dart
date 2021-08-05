import 'package:cats001/widgets/header.dart';
import 'package:cats001/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    super.initState();
  }

  Future<QuerySnapshot> getUsers() async {
    await Firebase.initializeApp();
    return await usersRef.get();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: FutureBuilder<QuerySnapshot>(
        future: getUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress(context);
          } else {
            final List<Text> children = snapshot.data!.docs
                .map((doc) => Text(doc['username']))
                .toList();
            return Container(
              child: ListView(
                children: children,
              ),
            );
          }
        },
      ),
    );
  }
}
