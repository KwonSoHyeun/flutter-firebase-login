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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // 컬렉션명
  final String colName = "Member";

  // 필드명
  final String fnName = "name";
  final String fnTel = "tel";
  final String fnDateTime = "datetime";

  TextEditingController _newNameCon = TextEditingController();
  TextEditingController _newTelCon = TextEditingController();
  TextEditingController _undNameCon = TextEditingController();
  TextEditingController _undTelCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("FirestoreFirstDemo")),
      body: ListView(
        children: <Widget>[
          Container(
            height: 500,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection(colName)
                  .orderBy(fnDateTime, descending: true)
                  .snapshots(),
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
                        Timestamp ts = document[fnDateTime];
                        String dt = timestampToStrDateTime(ts);
                        return Card(
                          elevation: 2,
                          child: InkWell(
                            // Read Document
                            onTap: () {
                              showDocument(document.documentID);
                            },
                            // Update or Delete Document
                            onLongPress: () {
                              showUpdateOrDeleteDocDialog(document);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        document[fnName],
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        dt.toString(),
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      document[fnTel],
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  )
                                ],
                              ),
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
      // Create Document
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: showCreateDocDialog),
    );
  }

  /// Firestore CRUD Logic

  // 문서 생성 (Create)
  void createDoc(String name, String tel) {
    Firestore.instance.collection(colName).add({
      fnName: name,
      fnTel: tel,
      fnDateTime: Timestamp.now(),
    });
  }

  // 문서 조회 (Read)
  void showDocument(String documentID) {
    Firestore.instance
        .collection(colName)
        .document(documentID)
        .get()
        .then((doc) {
      showReadDocSnackBar(doc);
    });
  }

  // 문서 갱신 (Update)
  void updateDoc(String docID, String name, String description) {
    Firestore.instance.collection(colName).document(docID).updateData({
      fnName: name,
      fnTel: description,
    });
  }

  // 문서 삭제 (Delete)
  void deleteDoc(String docID) {
    Firestore.instance.collection(colName).document(docID).delete();
  }

  void showCreateDocDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create New Document"),
          content: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: "Name"),
                  controller: _newNameCon,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Telephone"),
                  controller: _newTelCon,
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                _newNameCon.clear();
                _newTelCon.clear();
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Create"),
              onPressed: () {
                if (_newTelCon.text.isNotEmpty && _newNameCon.text.isNotEmpty) {
                  createDoc(_newNameCon.text, _newTelCon.text);
                }
                _newNameCon.clear();
                _newTelCon.clear();
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void showReadDocSnackBar(DocumentSnapshot doc) {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.deepOrangeAccent,
          duration: Duration(seconds: 5),
          content: Text("$fnName: ${doc[fnName]}\n$fnTel: ${doc[fnTel]}"
              "\n$fnDateTime: ${timestampToStrDateTime(doc[fnDateTime])}"),
          action: SnackBarAction(
            label: "Done",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
  }

  void showUpdateOrDeleteDocDialog(DocumentSnapshot doc) {
    _undNameCon.text = doc[fnName];
    _undTelCon.text = doc[fnTel];
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update/Delete Document"),
          content: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: "Name"),
                  controller: _undNameCon,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Telephone"),
                  controller: _undTelCon,
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                _undNameCon.clear();
                _undTelCon.clear();
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Update"),
              onPressed: () {
                if (_undNameCon.text.isNotEmpty && _undTelCon.text.isNotEmpty) {
                  updateDoc(doc.documentID, _undNameCon.text, _undTelCon.text);
                }
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Delete"),
              onPressed: () {
                deleteDoc(doc.documentID);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  String timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }
}
