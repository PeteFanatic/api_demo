// ignore_for_file: deprecated_member_use, duplicate_ignore, prefer_final_fields, unnecessary_null_comparison, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:api_demo/models/note.dart';
import 'package:api_demo/models/note_insert.dart';
import 'package:api_demo/services/note_service.dart';

class NoteModify extends StatefulWidget {
  final String noteID;
  // ignore: prefer_const_constructors_in_immutables
  NoteModify({required this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;

  NotesService get notesService => GetIt.I<NotesService>();

  String? errorMessage;
  Note? note;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      notesService.getNote(widget.noteID) {
        then((response) {
          setState(() {
            _isLoading = false;
          });

          if (response.error) {
            errorMessage = response.errorMessage ?? 'An error occurred';
          }
          note = response.data;
          _titleController.text = note.noteTitle;
          _contentController.text = note.noteContent;
        });
      };
    }
  }

  @override
  // ignore: unused_element
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit note" : "Create note")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Note title'),
                  ),
                  Container(height: 8),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(hintText: 'Note content'),
                  ),
                  Container(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: RaisedButton(
                      // ignore: sort_child_properties_last
                      child: const Text('Submit',
                          style: TextStyle(color: Colors.white)),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        if (isEditing) {
                          // update note
                        } else {
                          setState(() {
                            _isLoading = true;
                          });
                          final note = NoteInsert(
                              noteTitle: _titleController.text,
                              noteContent: _contentController.text);
                          final result = await notesService.createNote(note);

                          setState(() {
                            _isLoading = false;
                          });

                          // ignore: prefer_const_declarations
                          final title = 'Done';
                          final text = result.error!
                              ? (result.errorMessage ?? 'An error occurred')
                              : 'Your note was created';

                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text(title),
                                    content: Text(text),
                                    actions: <Widget>[
                                      // ignore: deprecated_member_use
                                      FlatButton(
                                        child: const Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  )).then((data) {
                            if (result.data!) {
                              Navigator.of(context).pop();
                            }
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
