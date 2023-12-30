


import 'package:cloud_firestore/cloud_firestore.dart';

import '../../commons.dart';


class DataRepositoryUnitType {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('unitType');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addUnitType(UnitType unitType) {
    return collection.add(unitType.toJson());
  }

  void updateUnitType(UnitType unitType) async {
    await collection.doc(unitType.referenceId).update(unitType.toJson());
  }

  void deleteUnitType(UnitType unitType) async {
    await collection.doc(unitType.referenceId).delete();
  }

}

class DataRepositoryUnitRole {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('unitRole');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  
  Stream<QuerySnapshot> getPublicStream() {
    return collection.where('public', isEqualTo: true).snapshots();
  }

  Future<DocumentReference> addUnitRole(UnitRole unitRole) {
    return collection.add(unitRole.toJson());
  }

  void updateUnitRole(UnitRole unitRole) async {
    await collection.doc(unitRole.referenceId).update(unitRole.toJson());
  }

  void deleteUnitRole(UnitRole unitRole) async {
    await collection.doc(unitRole.referenceId).delete();
  }
}

class DataRepositoryUnit {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('unit');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addUnit(Unit unit) {
    Map<String, dynamic> unitData = unit.toJson();
    return collection.add(unitData);
  }

  void updateUnit(Unit unit) async {
    await collection.doc(unit.referenceId).update(unit.toJson());
  }

  void deleteUnit(Unit unit) async {
    await collection.doc(unit.referenceId).delete();
  }

  Future<Unit?> getUnitById(String unitId) async {
    try {
      DocumentSnapshot documentSnapshot = await collection.doc(unitId).get();
      if (documentSnapshot.exists) {
        return Unit.fromSnapshot(documentSnapshot);
        
      }
      return null; // Return null if user with given ID doesn't exist
    } catch (e) {
      print("Error getting unit by ID: $e");
      return null;
    }
  }
}

class DataRepositoryUser {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('account');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  
  Stream<List<User>> getUsersStream() {
    return collection.snapshots().map((querySnapshot) {
      final accountList = querySnapshot.docs.map((documentSnapshot) {
        return User.fromSnapshot(documentSnapshot);
      }).toList();

      return accountList;
    });
  }

  Future<User?> getUserById(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await collection.doc(userId).get();
      if (documentSnapshot.exists) {
        return User.fromSnapshot(documentSnapshot);
        
      }
      return null; // Return null if user with given ID doesn't exist
    } catch (e) {
      print("Error getting user by ID: $e");
      return null;
    }
  }


  Future<DocumentReference> addUser(User account) {

    return collection.add(account.toJson());
  }

  Future<void> addUserWithId(User user) {
    print('tried to add');
    return collection.doc(user.referenceId).set(user.toJson());
  }

  void updateUser(User account) async {
    await collection.doc(account.referenceId).update(account.toJson());
  }

  void deleteUser(User account) async {
    await collection.doc(account.referenceId).delete();
  }
}