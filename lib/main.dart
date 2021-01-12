import 'package:miniproject/Screens/adminScreen.dart';
import 'package:miniproject/Screens/firstSignup.dart';
import 'package:miniproject/Screens/studentScreen.dart';
import 'package:miniproject/Widget/progress.dart';
import 'package:miniproject/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';

final studentRef = Firestore.instance.collection('student');
final adminRef = Firestore.instance.collection('admin');
final keyRef = Firestore.instance.collection('validKeys');
final validStudentRef = Firestore.instance.collection('validStudents');
final generatedKeysRef = Firestore.instance.collection('generatedKeys');

String curCname = "null";

final gSignIn = GoogleSignIn();
GoogleSignInAccount curGoogleAccount;
bool isRegistered = false;
User curUser;
bool isAuth = false;
bool isLoading = false;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini-Project1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    gSignIn.onCurrentUserChanged.listen((account) {
      handleSignin(account);
    }).onError((err) => {print('Error Occured in Google Sign In')});

    gSignIn.signInSilently();
  }

  void handleSignin(GoogleSignInAccount data) async {
    if (data != null) {
      curGoogleAccount = data;
      int status = 1; // 1 -> admin, 2 -> student,

      DocumentSnapshot doc = await adminRef.document(data.email).get();

      if (doc == null || doc.data == null) {
        print('Searching in validStudent');
        status = 2;
        doc = await validStudentRef.document(data.email).get();
      } else
        curUser = User.fromDocument(doc);

      if (status == 2 &&
          doc != null &&
          doc.data != null &&
          doc.data['isRegistered'] == true) {
        String university = doc['college'];
        curCname = university;
        doc = await studentRef
            .document(university)
            .collection(data.email)
            .document('data')
            .get();

        print(doc == null ? 'Null' : doc.data);
        if (doc == null || doc.data == null)
          return;
        else
          curUser = User.fromDocument(doc);
      }

      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  handleAdminLogin() async {
    User user = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => adminScreen()));
    setState(() {
      curUser = user;
      if (curUser == null) {
        gSignIn.disconnect();
        isAuth = false;
      }
    });
  }

  handleStudentLogin() async {
    User user = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => studentScreen()));
    setState(() {
      curUser = user;
      if (curUser == null) {
        gSignIn.disconnect();
        isAuth = false;
      }
    });
  }

  Widget validLogin() {
    return curUser.key != "null" ? handleAdminLogin() : handleStudentLogin();
  }

  handleFirstSignIn() async {
    User user = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                FirstSignUp(currentEmailId: curGoogleAccount.email)));
    setState(() {
      curUser = user;
      if (curUser == null) {
        gSignIn.disconnect();
        isAuth = false;
      }
    });
  }

  Widget buildAuth() {
    return Scaffold(body: curUser == null ? handleFirstSignIn() : validLogin());
  }

  Widget buildunAuth() {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [HexColor('#004e92'), HexColor('#000428')],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                  'Computerised   Fee  Collection  and  Transfer  Certificate',
                  style: TextStyle(
                      fontFamily: "Signatra",
                      fontSize: 50,
                      color: Colors.white)),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                print('Login Tapped!');
                gSignIn.signIn();
              },
              child: Container(
                height: 60,
                width: 260,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/google_signin_button.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            isLoading ? circularProgress(color: Colors.red) : Text('')
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuth() : buildunAuth();
  }
}
