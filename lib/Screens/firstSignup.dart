import 'package:miniproject/Widget/progress.dart';
import 'package:miniproject/main.dart';
import 'package:miniproject/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

int selectedOption = 1;
bool _obscureText = true;

TextEditingController idController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController keyController = TextEditingController();
TextEditingController collegeNameController = TextEditingController();

bool isIdValid = true;
bool isNameValid = true;
bool isKeyValid = true;
bool isCNameValid = true;
bool isRegistering = false;

class FirstSignUp extends StatefulWidget {
  final String currentEmailId;
  FirstSignUp({this.currentEmailId});

  @override
  _FirstSignUpState createState() => _FirstSignUpState();
}

class _FirstSignUpState extends State<FirstSignUp> {
  //1 - > Student
  //2 - > Staff

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [HexColor('004e92'), HexColor('#021B79')],
          ),
        ),
        child: Column(
          children: [
            isRegistering ? linearProgress() : Text(''),
            Center(
              child: Container(
                  margin: EdgeInsets.only(top: 30, bottom: 20),
                  height: selectedOption == 1 ? 700 : 730,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 100,
                        child: Center(
                          child: Text('Hello! let\'s register your account!',
                              style: TextStyle(
                                  fontFamily: "CustomFontAllesa",
                                  letterSpacing: 1.8,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                                child: GestureDetector(
                              onTap: () => {
                                setState(() {
                                  selectedOption = 1;
                                }),
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10, right: 5),
                                decoration: BoxDecoration(
                                  gradient: selectedOption == 1
                                      ? LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                              HexColor('#1488CC'),
                                              HexColor('#2B32B2')
                                            ])
                                      : LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                              Colors.white,
                                              Colors.white,
                                            ]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                height: 100,
                                child: Center(
                                  child: Text('Student',
                                      style: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          color: selectedOption == 1
                                              ? Colors.white
                                              : Colors.black,
                                          letterSpacing: 1,
                                          fontSize:
                                              selectedOption == 1 ? 22 : 18,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            )),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => {
                                  setState(() {
                                    selectedOption = 2;
                                  }),
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 5, right: 10),
                                  decoration: BoxDecoration(
                                    gradient: selectedOption == 2
                                        ? LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                                HexColor('#1488CC'),
                                                HexColor('##2B32B2')
                                              ])
                                        : LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                                Colors.white,
                                                Colors.white,
                                              ]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  height: 100,
                                  child: Center(
                                    child: Text('Administrator',
                                        style: TextStyle(
                                            fontFamily: "WorkSansSemiBold",
                                            color: selectedOption == 2
                                                ? Colors.white
                                                : Colors.black,
                                            letterSpacing: 1,
                                            fontSize:
                                                selectedOption == 2 ? 20 : 17,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      _buildSignIn(context),
                      selectedOption == 2
                          ? Card(
                              elevation: 3.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                width: 300.0,
                                height: isKeyValid ? 100 : 120.0,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.0,
                                          bottom: 20.0,
                                          left: 22.0,
                                          right: 25.0),
                                      child: TextField(
                                        controller: keyController,
                                        obscureText: _obscureText,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: TextStyle(
                                            fontFamily: "WorkSansSemiBold",
                                            fontSize: 16.0,
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                          errorText: isKeyValid
                                              ? null
                                              : 'Key should be at least 10 characters.',
                                          border: InputBorder.none,
                                          icon: Icon(
                                            FontAwesomeIcons.key,
                                            color: Colors.black,
                                            size: 22.0,
                                          ),
                                          suffix: GestureDetector(
                                            onTap: () => {
                                              setState(() {
                                                _obscureText =
                                                    _obscureText ^ true;
                                                ;
                                              }),
                                            },
                                            child: _obscureText
                                                ? Icon(
                                                    FontAwesomeIcons.eye,
                                                    color: Colors.black,
                                                    size: 18.0,
                                                  )
                                                : Icon(
                                                    FontAwesomeIcons.eyeSlash,
                                                    color: Colors.black,
                                                    size: 18.0,
                                                  ),
                                          ),
                                          hintText: "Enter your secret key",
                                          hintStyle: TextStyle(
                                              fontFamily: "WorkSansSemiBold",
                                              fontSize: 17.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Card(
                              elevation: 3.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                width: 300.0,
                                height: isKeyValid ? 100 : 120.0,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.0,
                                          bottom: 20.0,
                                          left: 22.0,
                                          right: 25.0),
                                      child: TextField(
                                        controller: collegeNameController,
                                        style: TextStyle(
                                            fontFamily: "WorkSansSemiBold",
                                            fontSize: 16.0,
                                            color: Colors.black),
                                        decoration: InputDecoration(
                                          errorText: isCNameValid
                                              ? null
                                              : 'College name can not be empty.',
                                          border: InputBorder.none,
                                          icon: Icon(
                                            FontAwesomeIcons.university,
                                            color: Colors.black,
                                            size: 22.0,
                                          ),
                                          hintText: "University",
                                          hintStyle: TextStyle(
                                              fontFamily: "WorkSansSemiBold",
                                              fontSize: 17.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                      //Button Start
                      GestureDetector(
                        onTap: !isRegistering
                            ? () {
                                print('Registering!');
                                setState(() {
                                  isRegistering = true;
                                });
                                handleRegister();
                              }
                            : null,
                        child: Container(
                          margin: EdgeInsets.only(top: 10, left: 10, right: 5),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  HexColor('#1488CC'),
                                  HexColor('#2B32B2')
                                ]),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          height: 60,
                          width: 300,
                          child: Center(
                            child: Text('Register',
                                style: TextStyle(
                                    fontFamily: "WorkSansSemiBold",
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w300)),
                          ),
                        ),
                      ),
                      //Button End
                    ],
                  )),
            ),
            Center(
                child: //Cancel
                    Container(
                        margin: EdgeInsets.all(15),
                        height: 80,
                        width: 120,
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context, null);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 10, bottom: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontFamily: "WorkSansSemiBold",
                                        color: Colors.white,
                                        fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ))),
          ],
        ),
      ),
    );
  } //build

  void handleRegister() async {
    //Note - student should exist in the database to register
    //That is, student details must be in the college database.
    //We check the ID and The name of the student against the stored data.
    //Check out DEV README for more information.
    print('\n\nIn handle Register');

    setState(() {
      isNameValid = nameController.text.trim().length == 0 ? false : true;
      isCNameValid =
          selectedOption != 2 && collegeNameController.text.trim().length == 0
              ? false
              : true;
      isIdValid = idController.text.trim().length < 10 ? false : true;
      isKeyValid = selectedOption == 2 && keyController.text.trim().length == 0
          ? false
          : true;
    });

    bool isValid = false;
    User user;

    if (isNameValid && isIdValid && isKeyValid && isCNameValid) {
      if (selectedOption == 1) {
        DocumentSnapshot doc =
            await studentRef.document(collegeNameController.text.trim()).get();

        if (doc != null && doc.data != null) {
          doc = await studentRef
              .document(collegeNameController.text.trim())
              .collection(widget.currentEmailId)
              .document('data')
              .get();
        }

        if (doc != null && doc.data != null) {
          user = User.fromDocument(doc);

          if (user.email == widget.currentEmailId &&
              user.name == nameController.text.trim() &&
              idController.text.trim() == user.id) {
            //current registration is valid
            isValid = true;
            await studentRef
                .document(collegeNameController.text.trim())
                .collection(widget.currentEmailId)
                .document('data')
                .updateData({
              'key': 'null',
              "isRegistered": true,
              "TcStatus": false,
              "paymentStatus": false
            });

            await validStudentRef.document(widget.currentEmailId).setData({
              "college": collegeNameController.text.trim(),
              "isRegistered": true
            });

            doc = await studentRef
                .document(collegeNameController.text.trim())
                .collection(widget.currentEmailId)
                .document('data')
                .get();

            user = User.fromDocument(doc);
          }
        }
      } else {
        //search in admin
        print('Registering admin');

        DocumentSnapshot doc =
            await keyRef.document(keyController.text.trim()).get();

        if (doc.data != null) {
          isValid = true;
          await adminRef.document(widget.currentEmailId).setData({
            'name': nameController.text.trim(),
            'email': widget.currentEmailId,
            'id': idController.text.trim(),
            'key': keyController.text.trim(),
            'isRegistered': true,
            "paymentStatus": false,
            "TcStatus": false
          });
          doc = await adminRef.document(widget.currentEmailId).get();
          user = User.fromDocument(doc);
          print('Registration succesful');
        }
      }
    }
    if (isValid) {
      Navigator.pop(context, user);
    }

    if (!isValid) {
      setState(() {
        isRegistering = false;
      });
      Alert(
        context: context,
        type: AlertType.error,
        title: "Invalid Entry",
        desc: "One or more entires are invalid. Try again.",
        buttons: [
          DialogButton(
            child: Text(
              "Try again",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    } //if is valid
  } //handle reg
} //main state class

Widget _buildSignIn(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(top: 23.0),
    child: Column(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // alignment: Alignment.topCenter,
          // overflow: Overflow.visible,
          children: <Widget>[
            Card(
              elevation: 3.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                width: 300.0,
                height: isNameValid ? 200 : 230.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                      child: TextField(
                        controller: idController,
                        style: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                            color: Colors.black),
                        decoration: InputDecoration(
                          errorText: isIdValid
                              ? null
                              : 'ID should be at least 10 characters.',
                          border: InputBorder.none,
                          icon: Icon(
                            FontAwesomeIcons.idBadge,
                            color: Colors.black,
                            size: 22.0,
                          ),
                          hintText: "ID Number",
                          hintStyle: TextStyle(
                              fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                        ),
                      ),
                    ),
                    Divider(
                      indent: 25,
                      endIndent: 25,
                      thickness: 1.0,
                      color: Colors.grey[350],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                      child: TextField(
                        controller: nameController,
                        style: TextStyle(
                            fontFamily: "WorkSansSemiBold",
                            fontSize: 16.0,
                            color: Colors.black),
                        decoration: InputDecoration(
                            errorText: isNameValid
                                ? null
                                : 'Name can\'t be an empty string.',
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: "Name",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: 17.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
