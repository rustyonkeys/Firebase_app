import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoneServices{

  //get collection of notes
  final CollectionReference notes = FirebaseFirestore.instance.collection("notes");

  //Create: add a new note
Future<void> addNote(String note){
  return notes.add({
    'note': note,
    'timestamp': Timestamp.now(),
  });
}

  //Read: get notes from database
//we are using stream for continuesly listen to any changes in te db
  Stream<QuerySnapshot> getNotesStream() {  // name of the function is called getNotesStream
  final notesStream = notes.orderBy("timestamp", descending: true).snapshots();  //we will now order the notes by timestamps and the newest one will be at the top
  return notesStream;
  }

  //Update: update notes given a doc id
  Future<void> updateNote(String docId, String newNote) { //will take docID to see which id to change and also update the new note
  return notes.doc(docId).update({
    'note' :newNote,
    'timestamp': Timestamp.now()
  });
  }
  //Delete: delete notes given a doc id
  Future<void> deleteNote(String docID){
  return notes.doc(docID).delete();
  }
}