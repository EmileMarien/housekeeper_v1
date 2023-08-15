import 'package:housekeeper_v1/commons.dart';

class UnitType { //Kinds of types for every unit, should work correctly
  String name;
  String? referenceId;
  // add final Unit; it can not change from unit
  UnitType({required this.name,this.referenceId});
  //TODO: add standard icon, amount of people, structure, ...

  factory UnitType.fromSnapshot(DocumentSnapshot snapshot) {
    final newUnitType = UnitType.fromJson(snapshot.data() as Map<String,dynamic>);
    newUnitType.referenceId = snapshot.reference.id;
    return newUnitType;
  }

  factory UnitType.fromJson(Map<String,dynamic> json) =>
    _unitTypeFromJson(json);

  Map<String,dynamic> toJson() => _unitTypeToJson(this);

  String getName() {return name;}

  @override
  String toString() => 'UnitType<$name>';

}

UnitType _unitTypeFromJson(Map<String, dynamic> json) {
  return UnitType(name: json['name'] as String,);
}

Map<String,dynamic> _unitTypeToJson(UnitType instance) => <String,dynamic>{
  'name':instance.name,
};

