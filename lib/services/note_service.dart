import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/models/user.dart';

class NoteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late CollectionReference<Map<String, dynamic>> ref;

  Stream<List<Note>> notes(User user) {
    final String path = 'users/${user.uid}/notes';
    ref = _db.collection(path);

    return ref.snapshots().map((query) {
      final List<Note> _notes = [];
      for (final doc in query.docs) {
        final note = Note.fromMap(doc.data());
        _notes.add(note);
      }
      return _notes;
    });
  }

  Future<void> addNote(User user, Note note) async {
    final String path = 'users/${user.uid}/notes';

    ref = _db.collection(path);

    final doc = ref.doc();
    final fNote = note.copyWith(id: doc.id);
    doc.set(fNote.toMap());
  }

  Future<void> updateNote(User user, Note note) async {
    final String path = 'users/${user.uid}/notes';
    _db.collection(path).doc(note.id).update(note.toMap());
  }

  Future<void> removeNote(User user, Note note) async {
    final String path = 'users/${user.uid}/notes';
    _db.collection(path).doc(note.id).delete();
  }
}
