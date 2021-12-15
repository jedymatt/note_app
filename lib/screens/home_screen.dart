import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/models/user.dart';
import 'package:note_app/services/auth_service.dart';
import 'package:note_app/services/note_service.dart';
import 'package:provider/provider.dart';

import 'add_note_screen.dart';
import 'note_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            onPressed: () async {
              final message = await context.read<AuthService>().signOut();
              // final message = await AuthService().signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: NoteService(user: context.read<User>()).notes,
        initialData: const <Note>[],
        builder: (context, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }

          if (snapshot.hasData) {
            final List<Note> notes = snapshot.data!;

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return _buildNote(notes[index]);
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // body: Consumer<UserNoteModel>(
      //   builder: (context, model, child) {
      //     return ListView.builder(
      //       itemCount: model.notes.length,
      //       itemBuilder: (context, index) {
      //         return _buildNote(model.notes[index]);
      //       },
      //     );
      // return ListView(
      //   children: model.notes.map((note) => _buildNote(note)).toList(),
      // );

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNote(Note note) {
    return Builder(builder: (context) {
      return Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(width: 1.0, color: Colors.black12),
        ),
        elevation: 0.0,
        margin: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteDetailScreen(note: note),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (note.title != '')
                    ? Text(
                        note.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      )
                    : const SizedBox.shrink(),
                (note.body != '') ? Text(note.body) : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
