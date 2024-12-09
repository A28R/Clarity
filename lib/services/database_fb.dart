import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clarity/models/data.dart';
import 'package:hive/hive.dart';

class DatabaseServiceFirebase {

  final CollectionReference dataStore =
  FirebaseFirestore.instance.collection('preferences');

  Future updateUserData(String theme, String model) async {
    print("changing settings");
    return await dataStore.doc("test").set({
      "colors":theme,
      "model": model
  });
  }
  MyUserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    print("getting settings (user Data)");
    return MyUserData(
      colors: snapshot.get('colors'),
      model: snapshot.get('model'),
    );
  }
  Stream<MyUserData> get data {
    return dataStore.doc("test").snapshots().map(_userDataFromSnapshot);
  }
}