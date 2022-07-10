// ignore_for_file: unnecessary_null_comparison, prefer_final_fields, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:api_demo/models/note.dart';
import 'package:api_demo/services/note_service.dart';

class NoteModify extends StatefulWidget {
  final String noteID;
  // ignore: use_key_in_widget_constructors
  const NoteModify({this.noteID = ''});

  @override
  // ignore: library_private_types_in_public_api
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;

  NotesService get notesService => GetIt.I<NotesService>();

  late String errorMessage;
  late Note note;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _isLoading = true;
    });
    notesService.getNote(widget.noteID).then((response) {
      setState(() {
        _isLoading = false;
      });

      if (response.error!) {
        errorMessage = response.errorMessage ?? 'An error occurred';
      }
      note = response.data!;
      _titleController.text = note.noteTitle!;
      _contentController.text = note.noteContent!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit note' : 'Create note')),
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
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      // ignore: sort_child_properties_last
                      child:
                          Text('Submit', style: TextStyle(color: Colors.white)),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
