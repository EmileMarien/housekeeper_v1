import 'package:housekeeper_v1/commons.dart';

class Unit {
  UnitType? type ;
  String? name;
  String? referenceId;
  Map<UnitRole, List<User>>? rolesAndUsers; // Map to associate roles with users

  Unit({this.name,this.rolesAndUsers,this.referenceId,this.type});

  factory Unit.fromSnapshot(DocumentSnapshot snapshot) {
    final newUnit = Unit.fromJson(snapshot.data() as Map<String,dynamic>);
    newUnit.referenceId = snapshot.reference.id;
    return newUnit;
  }
  
  String getName(){
    return name ?? '';
  }
  

  UnitType getType(){
    return type ?? UnitType(name: '');
  }

  // Add a user and associate it with a role in the unit
  /* TODO: remove
  void addUserWithRole(User user, UnitRole role) {
    if (user.units == null) {
      user.units =[this];
    } else {
      user.units!.add(this); // Associate the user with this unit and role
    }

    if (!rolesAndUsers.containsKey(role)) {
      rolesAndUsers[role] = [user]; // Create a new list for the role if it doesn't exist
    }
    rolesAndUsers[role]?.add(user); // Add the user to the list of users for the role
  }
  */ 
  
  void setName(String name){

    this.name=name;
  }

  void setType(UnitType type) {
    this.type=type;
  }

  factory Unit.fromJson(Map<String,dynamic> json) =>
    _unitFromJson(json);

  Map<String,dynamic> toJson() => _unitToJson(this);

  @override
  String toString() => 'Unit<$name>';
}

Unit _unitFromJson(Map<String,dynamic> json) {
  return Unit(
    name: json['name'] as String,
    type: UnitType.fromJson(json['type'] as Map<String, dynamic>), //UnitType JSON is map with String 'name' and dynamic the name
    
    rolesAndUsers: json['rolesAndUsers'] != null
            ? _rolesAndUsersFromJson(json['rolesAndUsers'] as Map<String, List<Map<String, dynamic>>>)
            : null  
  );
}

Map<UnitRole, List<User>> _rolesAndUsersFromJson(Map<String, List<Map<String,dynamic>>> rolesAndUsersMap) { //convert to Map<UnitRole,List<User>> from Json
  final rolesAndUsers = <UnitRole, List<User>>{};
  rolesAndUsersMap.forEach((key, value) {

    final role = UnitRole.fromString(key); //UnitRole(name: key['name'] as String, unit: Unit.fromJson(key['unit'] as Map<String, dynamic>));
    final users = _usersListFromJson(value as List<Map<String,dynamic>>);
    rolesAndUsers[role] = users;
  });
  return rolesAndUsers;
}

List<User> _usersListFromJson(List<Map<String,dynamic>> userList) { //convert Json list to list with users 
  final users = <User>[];
  for (final user in userList) {
    users.add(User.fromJson(user as Map<String, dynamic>));
  }
  return users;
}


Map<String, dynamic> _unitToJson(Unit instance) => <String, dynamic>{
    'name':instance.name,
    'type':instance.type is UnitType ? instance.type!.toJson() : null, //add map in map
    'rolesAndUsers': instance.rolesAndUsers is Map ? _rolesAndUsersToJson(instance.rolesAndUsers!) : null,  
  };

Map<String,List<Map<String,dynamic>>?>? _rolesAndUsersToJson(Map<UnitRole,List<User>> rolesAndUsers) {
  //if (rolesAndUsers == null) {return null;} //Uncomment if unit can be created separately without being linked to an user
  
  final rolesAndUsersMap = <String,List<Map<String, dynamic>>?>{};
  rolesAndUsers.forEach((key, value) {
    final role =key.toString();
    final usersList=_usersListToJson(value);
    rolesAndUsersMap[role]=usersList;
   });
return rolesAndUsersMap;
}

List<Map<String, dynamic>>? _usersListToJson(List<User>? users) { //convert list of users to list with Maps of users (Json format)
  if (users == null) {
    return null;
  }
  final usersList = <Map<String, dynamic>>[];
  users.forEach((user) {
    usersList.add(user.toJson());
  });
  return usersList;
}  

