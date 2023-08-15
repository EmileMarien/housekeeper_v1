import 'package:housekeeper_v1/commons.dart';

class UnitRole { //A UnitRole is not specific to an user and has a name and functions/restrictions for this user to a unit
  String name;
  //Unit? unit;
  String? referenceId;
  bool public;

  UnitRole({required this.name,this.public = false,this.referenceId});

  factory UnitRole.fromSnapshot(DocumentSnapshot snapshot) {
    final newUnitRole = UnitRole.fromJson(snapshot.data() as Map<String,dynamic>);
    newUnitRole.referenceId = snapshot.reference.id;
    return newUnitRole;
  }

  String getName() {return name;}

  factory UnitRole.fromJson(Map<String,dynamic> json) => _unitRoleFromJson(json);

  Map<String,dynamic> toJson() => _unitRoleToJson(this);

  // Factory method to create a UnitRole from the custom string representation
  factory UnitRole.fromString(String str) {
    // Extract name and public from the string
    final regex = RegExp(r'UnitRole<([^>]+)>_(true|false)');
    final match = regex.firstMatch(str);

    if (match != null && match.groupCount == 2) {
      final name = match.group(1);
      final public = match.group(2) == 'true';
      return UnitRole(name: name!, public: public);
    } else {
      throw FormatException('Invalid UnitRole string representation');
    }
  }  


  @override
  String toString() => 'UnitRole<$name>_$public';
}

Map<String, dynamic> _unitRoleToJson(UnitRole instance) => <String, dynamic>{
    'name':instance.name,
    //'unit':instance.unit?.toJson(),
    'public':instance.public,
  };

UnitRole _unitRoleFromJson(Map<String,dynamic> json) {
  return UnitRole(
    name: json['name'] as String,
    //unit: json['unit'] is Map // Unit JSON is a map with String the different entries and dynamic the corresponding values
    //  ? Unit.fromJson(json['unit'] as Map<String, dynamic>)
    //  : null, // If json['unit'] is not a Map, assign null
    public: json['public'] as bool,
  );
}
