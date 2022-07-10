import 'dart:convert';
import 'package:api_demo/models/api_response.dart';
import 'package:api_demo/models/note_for_listing.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

class NotesService {
  // ignore: constant_identifier_names
  static const API = 'http://api.notes.programingaddict.com';
  static const headers = {'apiKey': '09723c01-d5b8-4d7f-b0de-7d575abd9e9a'};
  Future<APIResponse<List<NoteForListing>>> getNotesList() {
    // ignore: prefer_interpolation_to_compose_strings
    return http.get(Uri.parse(API + '/notes'), headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <NoteForListing>[];
        for (var item in jsonData) {
          final note = NoteForListing(
            noteID: item['noteID'],
            noteTitle: item['noteTitle'],
            createDateTime: DateTime.parse(item['createDateTime']),
            latestEditDateTime: item['latestEditDateTime'] != null
                ? DateTime.parse(item['latestEditDateTime'])
                : null,
          );
          notes.add(note);
        }
        return APIResponse<List<NoteForListing>>(
          data: notes,
        );
      }
      return APIResponse<List<NoteForListing>>(
          error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<NoteForListing>>(
        error: true, errorMessage: 'An error occured'));
  }
}
