import 'package:housekeeper_v1/commons.dart';

class Note {
  String? title;
  String? description;
  String? referenceId;
  String? userId;
  String? unitId;

  Note({
    this.title,
    this.description,
    this.referenceId,
    this.unitId,
    required this.userId,
  });

  factory Note.fromSnapshot(DocumentSnapshot snapshot) {
    final newNote = Note.fromJson(snapshot.data() as Map<String, dynamic>);
    newNote.referenceId = snapshot.reference.id;
    return newNote;
  }

  void setTitle(title){
    this.title=title;
  }

  void setDescription(description){
    this.description=description;
  }
  String getTitle() {return title ?? "";}

  String getDescription() {return description ?? "";}

  factory Note.fromJson(Map<String, dynamic> json) => _noteFromJson(json);

  Map<String, dynamic> toJson() => _noteToJson(this);

  @override
  String toString() => 'Note<$title>';
}
 Note _noteFromJson(Map<String, dynamic> json) => Note(
  title: json['title'],
  description: json['description'],
  referenceId: json['referenceId'],
  unitId: json['unitId'],
  userId: json['userId'],

 );

Map<String, dynamic> _noteToJson(Note instance) => {
  'title': instance.title,
  'description': instance.description,
  'referenceId': instance.referenceId,
  'unitId': instance.unitId,
  'userId': instance.userId,

};