/// ***************************************************************
/// @file NotesList.dart
/// @brief note의 list의 인터페이스를 구체적으로 구현한 페이지
/// @details 생략
/// ***************************************************************

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'NotesDBWorker.dart';
import 'NotesModel.dart' show Note, NotesModel;
import 'package:provider/provider.dart';

/// @brief NotesList
/// @details (+)버튼, note의 list들 쫙 있음, 각 노트 옆으로 밀어서 삭제 가능.
/// @author 동호
/// @date 2020-12-09
/// @version 0.0.1
class NotesList extends StatelessWidget {
  @override
  Widget build(BuildContext inContext) {
    print("## NotesList.build()");

    return Consumer<NotesModel>(
      builder: (inContext, notesModel, _) {
        return Scaffold(
          // when the user push + button below routes
          // 새로 만드는 작업은 여기서 안함.
          // 단순히 + 버튼을 누르면 stack index 가 바뀌어서 화면이 이동하는 느낌임.
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // 새로운 노트를 만드는거니까 notesModel.entityBeingEdited 를 Note()로 새로 만듦.
              notesModel.entityBeingEdited = Note();
              // we do not want to pick color at first,
              notesModel.setColor(null);
              // if index == 1, then current route is moved to NotesEntry
              // NotesEntry shows editing or creating note
              notesModel.setStackIndex(1);
            },
          ),

          body: FutureBuilder(
            future: NotesDBWorker.db.getAll(),
            // future: notesModel.loadData("Notes", NotesDBWorker.db),
            // future: Provider.of<NotesModel>(inContext, listen: false).loadData("Notes", NotesDBWorker.db),
            builder: (inContext, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator()
                );
              }
              else{
                return  ListView.builder(
                  // itemCount: notesModel.entityList.length,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext inContext, int inIndex) {
                    Note note = snapshot.data[inIndex];
                    // default color is white.
                    Color color = Colors.white;
                    switch (note.color) {
                      case "red":
                        color = Colors.red;
                        break;
                      case "green":
                        color = Colors.green;
                        break;
                      case "blue":
                        color = Colors.blue;
                        break;
                      case "yellow":
                        color = Colors.yellow;
                        break;
                      case "grey":
                        color = Colors.grey;
                        break;
                      case "purple":
                        color = Colors.purple;
                        break;
                    }
                    // Container 쓴 이유: padding 주려고
                    return Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Slidable(
                        // 화면 밀 때 애니메이션 지정
                        actionPane: SlidableDrawerActionPane(),
                        // 화면 왼쪽으로 밀 때 action 지정
                        secondaryActions: [
                          IconSlideAction(
                            caption: "Delete",
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () => _deleteNote(inContext, note),
                          )
                        ],
                        // 얼마나 밀어야 action이 되는지 비율정하기
                        actionExtentRatio: 0.25,
                        // 요소 하나하나를 전부 Card로 하기
                        child: Card(
                          elevation: 8,
                          // 현재 notesModel.entityList[inIndex]의 color
                          color: color,
                          // ListView이니까 child는 ListTile로
                          child: ListTile(
                            title: Text("${note.title}"),
                            subtitle: Text("${note.content}"),
                            // 메모를 하나를 누르면 내가 수정, 즉 update 하겠다는 뜻
                            // 즉 어떤걸 수정하려고 할 때 notesModel.entityBeingEdited
                            // 를 통해 현 상황을 지속적으로 업데이트 해주는 것이 필요함
                            onTap: () async {
                              // 수정해주는 페이지로 가야하니까 수정할 놈으로 업데이트 해야함
                              notesModel.entityBeingEdited = await NotesDBWorker.db.get(note.id);
                              notesModel.setColor(notesModel.entityBeingEdited.color);
                              notesModel.setStackIndex(1);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }
}

///  @brief 특정 노트를 옆으로 슬라이드했을 때 삭제할 수 있는 기능 지원하는 함수
///  @date 2020-12-09
///  @param inContext 현재는 위치상 NotesList의 Scaffold의 context
///  @param inNote 현재 note
///  @return Future
Future _deleteNote(BuildContext inContext, Note inNote) async {
  print("## NotestList._deleteNote(): inNote = $inNote");

  NotesModel notesModel = Provider.of<NotesModel>(inContext, listen: false);

  return showDialog(
    context: inContext,
    // 알림 창 말고 다른 곳 눌러도 창이 안지워짐
    barrierDismissible: false,
    builder: (inAlertContext) {
      return AlertDialog(
        title: Text("Delete Note"),
        content: Text("Are you sure you want to delete ${inNote.title}?"),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(inAlertContext).pop();
            },
            child: Text("Cancel"),
          ),
          // Consumer<NotesModel>(
          //   builder: (inContext, notesModel, child) =>
          // ),
          FlatButton(
            child: Text("Delete"),
            onPressed: () async {
              // db에서 지우고
              NotesDBWorker.db.delete(inNote.id);
              // 창 닫고
              Navigator.of(inAlertContext).pop();
              // toast message 띄우고
              Scaffold.of(inContext).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 2),
                  content: Text("Note deleted!"),
                ),
              );
              // note list 업데이트 해줌
              // 이 함수는 함수안에서 notifyListeners() 호출하므로 자동으로 업데이트됨
              notesModel.loadData("notes", NotesDBWorker.db);
            },
          ),
        ],
      );
    },
  );
}
