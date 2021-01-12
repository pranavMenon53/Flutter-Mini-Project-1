import 'package:miniproject/Widget/progress.dart';
import 'package:flutter/material.dart';
import 'package:miniproject/main.dart';
import 'package:miniproject/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'dart:math' show Random;

class studentScreen extends StatefulWidget {
  @override
  _studentScreenState createState() => _studentScreenState();
}

class _studentScreenState extends State<studentScreen> {
  bool curTcStatus;
  bool isLoading = false;
  User user;
  String secrectKey = '';
  DateTime curKeyLimit;
  String _paymentString = 'Payment screen';

  @override
  void initState() {
    super.initState();
    findStatus();
    cleanGeneratedKeys();
  }

  cleanGeneratedKeys() async {
    QuerySnapshot temp = await generatedKeysRef.getDocuments();
    DateTime limit = DateTime.now();

    temp.documents.forEach((element) {
      DateTime temp = DateTime.parse(element['expiry']);
      if (limit.difference(temp).inMinutes >= 5) {
        element.reference.delete();
      }
    });
    // print('\n');
  }

  @override
  Widget build(BuildContext context) {
    print('Student Screen');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            actions: [
              FlatButton(
                  onPressed: () {
                    print('Clicked on logout!');
                    Navigator.pop(context, null);
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        letterSpacing: 2,
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ))
            ],
            backgroundColor: Colors.red,
            title: Text('Student Screen'),
            centerTitle: true,
            bottom: TabBar(
                labelColor: Colors.white,
                labelStyle: TextStyle(
                    fontSize: 20,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold),
                unselectedLabelColor: Colors.white,
                unselectedLabelStyle: TextStyle(
                    fontSize: 16,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w800),
                indicatorColor: Colors.deepPurple[600],
                indicatorWeight: 3,
                tabs: <Widget>[
                  Tab(text: 'TC'),
                  Tab(text: 'Payment'),
                ]),
          ),
          body: TabBarView(children: [
            buildTc(),
            buildPayment(context),
          ])),
    );
  } //build

  Widget buildTc() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: !isLoading ? buildTCScreen() : [circularProgress()],
        ),
      ),
    );
  }

  void findStatus() async {
    setState(() {
      isLoading = true;
    });

    DocumentSnapshot temp = await studentRef
        .document(curCname)
        .collection(curUser.email)
        .document('data')
        .get();

    // print('\n\nIn find status');
    // print(temp.data);
    curUser = User.fromDocument(temp);
    setState(() {
      isLoading = false;
      curTcStatus = temp['TcStatus'];
    });
  }

  List<Widget> buildTCScreen() {
    return [
      loadTCStatus(),
      SizedBox(height: 15),
      RaisedButton(
        onPressed: () {
          print('Reloading!');
          findStatus();
        },
        padding: EdgeInsets.all(10),
        color: Colors.red,
        child: Text(
          'Reload',
          style: TextStyle(
              fontFamily: "WorkSansSemiBold",
              color: Colors.white,
              fontSize: 20),
        ),
      ),
    ];
  }

  Widget loadTCStatus() {
    String tcNotReady = 'Dear Student, your TC has not been issued yet.';
    String tcReady =
        'Dear Student, your TC has been issued. Collect your certificate at the office during college hours.';

    return LimitedBox(
      maxWidth: MediaQuery.of(context).size.width * 0.6,
      child: Text(curTcStatus ? tcReady : tcNotReady,
          style: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 25)),
    );
  }

  updateKey(key) async {
    // print('\nIn Update key');
    await generatedKeysRef.document(key).setData({
      'collegeName': curCname,
      'email': curUser.email,
      'expiry': DateTime.now().toString()
    });
  }

  Widget buildPayment(context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(_paymentString,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          RaisedButton(
            onPressed: () {
              print('Making a Payment!');
              // print('\n\nDiff : ${curKeyLimit != null ? DateTime.now().difference(curKeyLimit).inMinutes : null}\n');
              if (curKeyLimit != null &&
                  DateTime.now().difference(curKeyLimit).inMinutes >= 2) {
                generatedKeysRef.document(secrectKey).delete();
                secrectKey = '';
              }

              if (secrectKey == '' && !curUser.paymentStatus) {
                cleanGeneratedKeys();
                secrectKey = randomAlphaNumeric(9);
                setState(() {
                  _paymentString = 'Your secrect key is : ' + secrectKey;
                });
                curKeyLimit = DateTime.now();
                updateKey(secrectKey);
              } else {
                Fluttertoast.showToast(
                  timeInSecForIosWeb: 3,
                  fontSize: 24,
                  msg:
                      "Your key has alredy been generated or your payment has already been done!",
                  toastLength: Toast.LENGTH_LONG,
                );
              }
            }, //on pressed
            padding: EdgeInsets.all(10),
            color: Colors.red,
            child: Text(
              'Make a payment',
              style: TextStyle(
                  fontFamily: "WorkSansSemiBold",
                  color: Colors.white,
                  fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
