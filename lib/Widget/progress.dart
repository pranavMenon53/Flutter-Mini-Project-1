import 'package:flutter/material.dart';

circularProgress({color : Colors.blue}) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top : 10),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(color),
    ),
  );
}

linearProgress() {
  return Container(
    padding: EdgeInsets.only(bottom : 10),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.white),
    ),
  );
}
