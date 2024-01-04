
import '../../../commons.dart';
import '../models/note.dart';

class DataRepositoryNotes {
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('notes');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  Stream<QuerySnapshot> getUnitStream(String userid) {
    return collection.where('userId', isEqualTo: userid).snapshots();
  }

  Future<DocumentReference> addNote(Note note) {
    Map<String, dynamic> noteData = note.toJson();
    return collection.add(noteData);
  }

  void updateNote(Note note) async {
    await collection.doc(note.referenceId).update(note.toJson());
  }

  void deleteNote(Note note) async {
    await collection.doc(note.referenceId).delete();
  }

}