import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id; //roll
  final String name;
  final String email;
  final String key; //for
  final bool isRegistered;
  final bool paymentStatus;
  final bool tcStatus;

  User(
      {this.id,
      this.name,
      this.email,
      this.key,
      this.isRegistered,
      this.paymentStatus,
      this.tcStatus});

  factory User.fromDocument(DocumentSnapshot doc) {
    return new User(
      id: doc['id'],
      name: doc['name'],
      email: doc['email'],
      key: doc['key'] != "null" ? doc['key'] : 'null',
      isRegistered: doc['isRegistered'],
      paymentStatus: doc['paymentStatus'],
      tcStatus: doc['TcStatus'],
    );
  }
}
