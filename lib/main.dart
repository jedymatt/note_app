import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_app/firebase_options.dart';
import 'package:note_app/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/note_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => AuthService(),
        ),
        StreamProvider.value(
          value: AuthService().user,
          initialData: null,
        ),
        Provider(
          create: (context) => NoteService(),
        ),
      ],
      child: const App(),
    ),
  );
}
