import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {

  static String Collection_Name = 'MyUser';
  late String id;
  late String name;
  late String email;
  MyUser({required this.id, required this.name, required this.email});

  MyUser.fromJson(Map<String, Object?> json)
      : this(
    id: json['id']! as String,
    name: json['name']! as String,
    email: json['email']! as String,
  );



  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  static CollectionReference withConverter(){
    return  FirebaseFirestore.instance.collection(Collection_Name).withConverter<MyUser>(
      fromFirestore: (snapshot, _) => MyUser.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );
  }
}