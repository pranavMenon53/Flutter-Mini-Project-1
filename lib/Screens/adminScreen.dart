import 'package:miniproject/Widget/customTile.dart';
import 'package:miniproject/Widget/progress.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/main.dart';
import 'package:miniproject/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String cName = '';
List<Widget> tcList = [];
List<Widget> paymentList = [];
// List<User> students = [];
List<DocumentSnapshot> studentDetails = [];

class adminScreen extends StatefulWidget {
  @override
  _adminScreenState createState() => _adminScreenState();
}

class _adminScreenState extends State<adminScreen> {
  @override
  void initState() async {
    super.initState();

    setState(() {
      tcList = [];
      paymentList = [];
      studentDetails = [];
    });

    print('In initState of adminScreen');
    await getCollege();
  }

  getCollege() async {
    DocumentSnapshot doc = await keyRef.document(curUser.key).get();
    cName = doc['collegeName'];
    await getStudents();
  }

  getStudents() async {
    QuerySnapshot doc = await validStudentRef.getDocuments();
    await addDocuments(doc);
    buildTCList();
    buildPaymentList();
  }

  buildAgain(context) async {
    buildTCList();
    buildPaymentList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              title: Text('Admin Screen',
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 2,
                  )),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                          letterSpacing: 2,
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )),
                FlatButton(
                    onPressed: () async {
                      setState(() {
                        tcList = [];
                        paymentList = [];
                        studentDetails = [];
                      });
                      await this.getStudents();
                      // getStudents();
                    },
                    child: Text(
                      'reload',
                      style: TextStyle(
                          letterSpacing: 2,
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ))
              ],
              backgroundColor: Colors.red,
              centerTitle: true,
              bottom: TabBar(
                labelColor: Colors.white,
                labelStyle: TextStyle(
                    fontSize: 20,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold),
                unselectedLabelColor: Colors.white,
                unselectedLabelStyle: TextStyle(
                    fontSize: 14,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w800),
                indicatorColor: Colors.accents[0],
                indicatorWeight: 3,
                tabs: [Tab(text: 'TC status'), Tab(text: 'Payment status')],
              )),
          body: TabBarView(
            children: [
              Container(
                  child: tcList.length == 0
                      ? circularProgress()
                      : ListView(
                          children: tcList,
                        )),
              Container(
                  child: paymentList.length == 0
                      ? circularProgress()
                      : ListView(children: paymentList))
            ],
          )),
    );
  } //build

  void buildTCList() {
    setState(() {
      tcList = [];
    });

    List<Widget> temp = [];
    int i = 0;
    for (DocumentSnapshot doc in studentDetails) {
      temp.add(customTile(User.fromDocument(doc), cName, 0, i, changeList));
      i += 1;
    }
    setState(() {
      tcList = temp;
    });
  } //buildTClist

  void buildPaymentList() {
    List<Widget> temp = [];
    setState(() {
      paymentList = [];
    });

    var i = 0;
    for (DocumentSnapshot doc in studentDetails) {
      temp.add(customTile(User.fromDocument(doc), cName, 1, i, changeList));
      i += 1;
    }

    setState(() {
      paymentList = temp;
    });

    // return paymentList;
  }

  void changeList(index, state, newValue) async {
    var email = studentDetails[index].data['email'];
    DocumentSnapshot doc = await studentRef
        .document(cName)
        .collection(email)
        .document('data')
        .get();

    setState(() {
      studentDetails[index] = doc;
    });

    if (state == 0)
      buildTCList();
    else
      buildPaymentList();
  }

  Future<void> addDocuments(QuerySnapshot doc) async {
    int n = doc.documents.length;

    for (int i = 0; i < n; i++) {
      DocumentSnapshot element = doc.documents[i];
      if (element.data['college'] == cName) {
        DocumentSnapshot temp = await studentRef
            .document(cName)
            .collection(element.reference.documentID)
            .document('data')
            .get();

        setState(() {
          studentDetails.add(temp);
        });
      }
    }
  }
} //class
