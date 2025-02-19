import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes = 
    FirebaseFirestore.instance.collection('notes');
  
  //add notes
  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }
  //display notes
   Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
      notes.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }
  //update feature
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }
  //delete
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}