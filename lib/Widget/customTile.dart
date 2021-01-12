import 'package:miniproject/Screens/adminScreen.dart';
import 'package:miniproject/main.dart';
import 'package:miniproject/models/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class customTile extends StatefulWidget {
  String cName;
  User user;
  int state;
  int index;
  var fun;
  // Widget trailing;
  // state = 0 -> tc
  // state = 1 -> payment
  customTile(this.user, this.cName, this.state, this.index, this.fun);

  @override
  _customTileState createState() => _customTileState();
}

class _customTileState extends State<customTile> {
  bool curStatus;

  @override
  void initState() {
    super.initState();
    curStatus =
        widget.state == 0 ? widget.user.tcStatus : widget.user.paymentStatus;
  }

  updateStatus(newVal) async {
    await studentRef
        .document(widget.cName)
        .collection(widget.user.email)
        .document('data')
        .updateData(widget.state == 0
            ? {'TcStatus': newVal}
            : {'paymentStatus': newVal});

    widget.fun(widget.index, widget.state, newVal);

    // setState(() {
    //   studentDetails[widget.index]
    //       .data[widget.state == 0 ? 'TcStatus' : 'paymentStatus'] = newVal;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        ListTile(
          leading: Icon(FontAwesomeIcons.user, color: Colors.black, size: 20),
          title: Text(widget.cName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.id,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              Text(widget.user.name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))
            ],
          ),
          trailing:
              // widget.trailing
              Switch(
                  activeColor: Colors.green,
                  value: curStatus,
                  onChanged: (newVal) {
                    setState(() {
                      curStatus = newVal;
                    });
                    updateStatus(newVal);
                  }),
        ),
        SizedBox(height: 10),
        Divider(indent: 10, endIndent: 10, thickness: 1, color: Colors.black12)
      ],
    );
  }
}
