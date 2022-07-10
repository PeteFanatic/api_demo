import 'package:api_demo/services/note_service.dart';
import 'package:api_demo/views/note_list.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:get_it/get_it.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => NotesService());
}

void main() {
  setupLocator();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteList(),
    );
  }
}
