import 'package:api_demo/models/api_response.dart';
import 'package:api_demo/views/note_modify.dart';
import 'package:flutter/material.dart';
import 'package:api_demo/views/note_delete.dart';
import 'package:api_demo/services/note_service.dart';
import '../models/note_for_listing.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:get_it/get_it.dart';

// ignore: use_key_in_widget_constructors
class NoteList extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NotesService get service => GetIt.I<NotesService>();

  APIResponse<List<NoteForListing>>? _apiResponse;
  bool _isLoading = false;
  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNotesList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('List of notes')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => NoteModify()));
          },
          child: const Icon(Icons.add),
        ),
        body: Builder(
          builder: (_) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (_apiResponse!.error!) {
              return Center(child: Text(_apiResponse!.errorMessage!));
            }
            return ListView.separated(
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Colors.green),
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(_apiResponse!.data![index].noteID),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context, builder: (_) => NoteDelete());
                    // ignore: avoid_print
                    print(result);
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.only(left: 16),
                    child: const Align(
                      // ignore: sort_child_properties_last
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      _apiResponse!.data![index].noteTitle!,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    subtitle: Text(
                        'Last edited on ${formatDateTime(_apiResponse!.data![index].latestEditDateTime ?? _apiResponse!.data![index].createDateTime)}'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => NoteModify(
                              noteID: _apiResponse!.data![index].noteID!)));
                    },
                  ),
                );
              },
              itemCount: _apiResponse!.data!.length,
            );
          },
        ));
  }
}
