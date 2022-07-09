// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class NoteModify extends StatelessWidget {
  final String noteID;
  // ignore: unnecessary_null_comparison
  bool get isEditing => noteID != null;
  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  NoteModify({Key? key, this.noteID = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: unnecessary_null_comparison
      appBar: AppBar(title: Text(isEditing ? 'Create note' : 'Edit note')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(hintText: 'Note title'),
            ),
            Container(height: 8),
            const TextField(
              decoration: InputDecoration(hintText: 'Note content'),
            ),
            Container(height: 16),
            SizedBox(
              width: double.infinity,
              height: 35,
              child: RaisedButton(
                child: Text('Submit', style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (isEditing) {
                  } else {}
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
