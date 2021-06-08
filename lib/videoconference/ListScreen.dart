import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../variable.dart';

class ListScreen extends StatefulWidget {
  var roomid;

  ListScreen(var roomid)
  {
    this.roomid = roomid;
  }
  @override
  _ListScreenState createState() => _ListScreenState(roomid);
}

class _ListScreenState extends State<ListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var roomid;
  List studentList =[];
  _ListScreenState(var roomid)
  {
    this.roomid =roomid;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Attendance"
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('meet').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.hasData)
              {
                studentList.clear();
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context,index)
                            {
                              if(roomid == snapshot.data.docs[index].get("meeting id"))
                                {
                                  studentList.add(snapshot.data.docs[index]);
                                  print("my length : " + studentList.length.toString());
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom:8.0),
                                    child: Container(
                                      height: 60,
                                      color: Colors.grey[350],
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              "Name :" + snapshot.data.docs[index].get("name"),
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "enrollment number :" + snapshot.data.docs[index].get("enrollment number"),
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () => getCsv(),
                          child: Container(
                            width: double.maxFinite,
                            height: 64,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: GradientColors.darkPink)),
                            child: Center(
                              child: Text(
                                "Download list",
                                style: mystyle(20, Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            /*return ListView(
              children: snapshot.data.docs.map((document) {
                return Container(
                  child: Center(child: Text(document['name'])),
                );
              }).toList(),
            );*/
          },
        ),
      ),
    );
  }

  getCsv() async {
    List<List<dynamic>> rows = List<List<dynamic>>();
    print("student length" + studentList.length.toString());
    for (int i = 0; i < studentList.length; i++) {
      List row = [];
      row.add(studentList[i].get("meeting id"));
      row.add(studentList[i].get("enrollment number"));
      row.add(studentList[i].get("name"));
      rows.add(row);
    }
    print("rows" + rows.toString());
      print("hello world");
      File dir = await _localFile;
      print(dir);
      dir.openWrite();
      String csv = const ListToCsvConverter().convert(rows);
      dir.writeAsString(csv);
      _showScaffold("Successfully downloaded");
  }
  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/list.csv',);
  }
}
