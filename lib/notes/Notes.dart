import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'NotesDBWorker.dart';
import 'NotesList.dart';
import 'NotesEntry.dart';
import 'NotesModel.dart' show NotesModel;

/// ***************************************************************
/// The Notes screen.
/// ***************************************************************
class Notes extends StatelessWidget {
  bool initial;

  Notes(){
    print("## Notes.Constructor()");
    initial = true;
  }

  Widget build(BuildContext context) {
    print("## Notes.build()");

    return ChangeNotifierProvider.value(
      // create: (_) => NotesModel(),
      value: NotesModel(),
      builder: (inContext, inChild) {

        // if(initial){
        //   Provider.of<NotesModel>(inContext, listen: false).loadData("Notes", NotesDBWorker.db);
        //   initial = false;
        // }

        return GestureDetector(
          onTap: () => FocusScope.of(inContext).requestFocus(FocusNode()),
          child: IndexedStack(
            index: Provider.of<NotesModel>(inContext).stackIndex,
            children: [
              NotesList(),
              NotesEntry(),
            ],
          ),
        );
      },
    );
  }
}
