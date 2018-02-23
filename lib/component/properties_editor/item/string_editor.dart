import 'dart:html' as html;
import 'state.dart';
import 'package:domino/domino.dart';
import 'package:domino_nodes/domino_nodes.dart';
import 'package:client/service/data.dart';

class EditableText implements Component, Input<String> {
  final String value;

  final String key;

  final StringCallBack onInput;

  EditableElementState myState;

  EditableText(this.value, {this.key, this.onInput}) {
    myState = storage.insertIfNotExists(key, new EditableElementState(value));
  }

  @override
  dynamic build(BuildContext context) {
    if (!myState.isEditing)
      return div(content: value, set: [
        clazz('propitem-editabletxt', 'not-editing'),
        onClick((_) {
          myState.isEditing = true;
        })
      ]);
    else {
      if (myState.el == null) {
        myState.el = textInput(
            set: [
              attr('value', value),
              onBlur((Event e) {
                if (onInput != null) {
                  onInput((e.domElement as html.InputElement).value);
                }
                myState.isEditing = false;
                myState.el = null;
                storage.remove(key);
              })
              /* TODO
          onKeyPress((Event e) {
            final html.KeyboardEvent event = e.domEvent;
            if (event.keyCode == html.KeyCode.ENTER) {
              state.editingPage.name =
                  (event.target as html.InputElement).value;
              myState.isEditing = false;
              myState.el = null;
              storage.remove(key);
            }
          })
          */
            ],
            key: key,
            afterInsert:
                ((html.Element node) => node.focus()) as AfterCallback);
      }
      return div(content: myState.el, set: [clazz('propitem-editabletxt')]);
    }
  }
}
