import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/models/user.dart';

class NoteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late CollectionReference<Map<String, dynamic>> ref;
  final User user;

  NoteService({required this.user});

  Stream<List<Note>> get notes {
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

  Future<void> addNote(Note note) async {
    final String path = 'users/${user.uid}/notes';

    ref = _db.collection(path);

    final doc = ref.doc();
    final fNote = note.copyWith(id: doc.id);
    doc.set(fNote.toMap());
  }

  Future<void> updateNote(Note note) async {
    final String path = 'users/${user.uid}/notes';
    _db.collection(path).doc(note.id).update(note.toMap());
  }

  Future<void> removeNote(Note note) async {
    final String path = 'users/${user.uid}/notes';
    _db.collection(path).doc(note.id).delete();
  }
}
