/// ***************************************************************
/// @file NotesEntry.dart
/// @brief note 만들 때 (편집할 때) 나오는 화면
/// @details below
/// ***************************************************************

import 'package:flutter/material.dart';
import 'NotesDBWorker.dart';
import 'NotesModel.dart' show NotesModel;
import 'package:provider/provider.dart';

/// @brief note 만들거나 편집할 때 나오는 라우트
/// @details ㄱㄷ
/// @author 동호
/// @date 2020-12-09
/// @version 0.0.1
class NotesEntry extends StatelessWidget {
  /// A controller for an editable text field.
  ///
  /// Whenever the user modifies a text field with an associated
  /// [TextEditingController], the text field updates [value] and the controller
  /// notifies its listeners. Listeners can then read the [text] and [selection]
  /// properties to learn what the user has typed or how the selection has been
  /// updated.
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController =
      TextEditingController();

  // Key for form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext inContext) {
    print("## NotesEntry.build()");

    return Consumer<NotesModel>(
      builder: (inContext, notesModel, child) {

        print("## NotesEntry.Consumer");

        _titleEditingController.addListener(() =>
        notesModel.entityBeingEdited.title = _titleEditingController.text);

        _contentEditingController.addListener(() =>
        notesModel.entityBeingEdited.content = _contentEditingController.text);

        // 이렇게 하면 controller 의 text 에 기본값을 지정해주니까
        // 전에 user 가 입력한 내용을 화면에 띄워줄 수 있음.
        if (notesModel.entityBeingEdited != null) {
          _titleEditingController.text = notesModel.entityBeingEdited.title;
          _contentEditingController.text = notesModel.entityBeingEdited.content;
        }

        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Row(
              children: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    // inContext에 해당하는 Focus를 가져와 FucusNode()에 준다.
                    // 즉 현재 focus인 (may be) 키보드의 포커스를 허공에 날려버려
                    // 키보드를 내려가게 하는 걸 존나 어렵게 쓴거임.
                    FocusScope.of(inContext).requestFocus(FocusNode());
                    // 리스트 화면으로 ㄱ
                    notesModel.setStackIndex(0);
                  },
                ),
                Spacer(),
                FlatButton(
                  child: Text("Save"),
                  onPressed: () => _save(inContext, notesModel),
                ),
              ],
            ),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.title),
                  title: TextFormField(
                    controller: _titleEditingController,
                    decoration: InputDecoration(hintText: "Title"),
                    validator: (inValue) {
                      if (inValue.length == 0) {
                        return "Please enter a title";
                      }
                      return null;
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.content_paste),
                  title: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 8,
                    controller: _contentEditingController,
                    decoration: InputDecoration(hintText: "Content"),
                    validator: (inValue) {
                      if (inValue.length == 0) {
                        return "Please enter content";
                      }
                      return null;
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.color_lens_rounded),
                  title: Row(
                    children: [
                      GestureDetector(
                          child: Container(
                              decoration: ShapeDecoration(
                                  shape:
                                      Border.all(color: Colors.red, width: 18) +
                                          Border.all(
                                              width: 6,
                                              color: notesModel.color == "red"
                                                  ? Colors.red
                                                  : Theme.of(inContext)
                                                      .canvasColor))),
                          onTap: () {
                            notesModel.entityBeingEdited.color = "red";
                            notesModel.setColor("red");
                          }),
                      Spacer(),
                      GestureDetector(
                          child: Container(
                              decoration: ShapeDecoration(
                                  shape: Border.all(
                                          color: Colors.green, width: 18) +
                                      Border.all(
                                          width: 6,
                                          color: notesModel.color == "green"
                                              ? Colors.green
                                              : Theme.of(inContext)
                                                  .canvasColor))),
                          onTap: () {
                            notesModel.entityBeingEdited.color = "green";
                            notesModel.setColor("green");
                          }),
                      Spacer(),
                      GestureDetector(
                          child: Container(
                              decoration: ShapeDecoration(
                                  shape: Border.all(
                                          color: Colors.blue, width: 18) +
                                      Border.all(
                                          width: 6,
                                          color: notesModel.color == "blue"
                                              ? Colors.blue
                                              : Theme.of(inContext)
                                                  .canvasColor))),
                          onTap: () {
                            notesModel.entityBeingEdited.color = "blue";
                            notesModel.setColor("blue");
                          }),
                      Spacer(),
                      GestureDetector(
                          child: Container(
                              decoration: ShapeDecoration(
                                  shape: Border.all(
                                          color: Colors.yellow, width: 18) +
                                      Border.all(
                                          width: 6,
                                          color: notesModel.color == "yellow"
                                              ? Colors.yellow
                                              : Theme.of(inContext)
                                                  .canvasColor))),
                          onTap: () {
                            notesModel.entityBeingEdited.color = "yellow";
                            notesModel.setColor("yellow");
                          }),
                      Spacer(),
                      GestureDetector(
                          child: Container(
                              decoration: ShapeDecoration(
                                  shape: Border.all(
                                          color: Colors.grey, width: 18) +
                                      Border.all(
                                          width: 6,
                                          color: notesModel.color == "grey"
                                              ? Colors.grey
                                              : Theme.of(inContext)
                                                  .canvasColor))),
                          onTap: () {
                            notesModel.entityBeingEdited.color = "grey";
                            notesModel.setColor("grey");
                          }),
                      Spacer(),
                      GestureDetector(
                        child: Container(
                            decoration: ShapeDecoration(
                                shape: Border.all(
                                        color: Colors.purple, width: 18) +
                                    Border.all(
                                        width: 6,
                                        color: notesModel.color == "purple"
                                            ? Colors.purple
                                            : Theme.of(inContext)
                                                .canvasColor))),
                        onTap: () {
                          notesModel.entityBeingEdited.color = "purple";
                          notesModel.setColor("purple");
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///  @brief  note 수정페이지에서 save 기능
  ///  @date   2020-12-09
  ///  @param  inContext 현재는 위치상 scoped 모델
  ///  @param  inNote 현재 note
  ///  @return Future
  Future _save(BuildContext inContext, NotesModel inModel) async {

    // NotesModel notesModel = Provider.of<NotesModel>(inContext, listen: false);

    if (!_formKey.currentState.validate()) {
      return;
    }
    //
    // // create
    // if (inModel.entityBeingEdited.id == null) {
    //   print("## NotesEntry._save(): Creating: ${inModel.entityBeingEdited}");
    //   await NotesDBWorker.db.create(notesModel.entityBeingEdited);
    // }
    // // update
    // else {
    //   print("## NotesEntry._save(): Updating: ${inModel.entityBeingEdited}");
    //   await NotesDBWorker.db.update(notesModel.entityBeingEdited);
    // }
    //
    // notesModel.loadData("note", NotesDBWorker.db);


    // create
    if (inModel.entityBeingEdited.id == null) {
      print("## NotesEntry._save(): Creating: ${inModel.entityBeingEdited}");
      await NotesDBWorker.db.create(inModel.entityBeingEdited);
    }
    // update
    else {
      print("## NotesEntry._save(): Updating: ${inModel.entityBeingEdited}");
      await NotesDBWorker.db.update(inModel.entityBeingEdited);
    }

    inModel.loadData("note", NotesDBWorker.db);

    inModel.setStackIndex(0);

    Scaffold.of(inContext).showSnackBar(SnackBar(
      content: Text("Note saved"),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
    ));
  }
}
