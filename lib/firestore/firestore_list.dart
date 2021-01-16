import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirestoreFirstDemoState pageState;

class FirestoreFirstDemo extends StatefulWidget {
  @override
  FirestoreFirstDemoState createState() {
    pageState = FirestoreFirstDemoState();
    return pageState;
  }
}

class FirestoreFirstDemoState extends State<FirestoreFirstDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FirestoreFirstDemo")),
      body: Column(
        children: <Widget>[
          Container(
            height: 500,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("Member").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text("Error: ${snapshot.error}");
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text("Loading...");
                  default:
                    return ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        //Timestamp tt = document["datetime"];
                        //DateTime dt = DateTime.fromMicrosecondsSinceEpoch(
                        //    tt.microsecondsSinceEpoch);

                        return Card(
                          elevation: 2,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      document["name"],
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      document["name"],
                                      style: TextStyle(color: Colors.grey[600]),
                                    )
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    document["tel"],
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
