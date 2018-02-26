import 'dart:html' as html;
import 'state.dart';
import 'package:domino/domino.dart';
import 'package:domino_nodes/domino_nodes.dart';

class EditableText implements StatefulComponent, Input<String> {
  final String value;

  final String key;

  final StringCallBack onInput;

  EditableElementState myState;

  EditableText(this.value, {this.key, this.onInput});

  @override
  dynamic build(BuildContext context) {
    if (!myState.isEditing)
      return div([
        clazz('propitem-editabletxt', 'not-editing'),
        when(key != null, new Symbol(key)),
        value,
        onClick((_) {
          myState.isEditing = true;
          myState.isStartingEditing = true;
        }),
      ]);
    else {
      bool isStartingEditing = myState.isStartingEditing;
      myState.isStartingEditing = false;
      return div([
        // when(key != null, new Symbol(key)),
        textInput([
          when(isStartingEditing, attr('value', value)),
          onBlur((Event e) {
            if (myState.isEditing && onInput != null) {
              onInput((e.element as html.InputElement).value);
            }
            myState.isEditing = false;
          }),
          onKeyDown((Event e) {
            final html.KeyboardEvent event = e.event;
            if (event.keyCode == html.KeyCode.ENTER) {
              if (myState.isEditing && onInput != null) {
                onInput((e.element as html.InputElement).value);
              }
              myState.isEditing = false;
            } else if (event.keyCode == html.KeyCode.ESC) {
              myState.isEditing = false;
            }
          }),
          new Symbol(key),
          afterInsert((Change change) => change.node.focus())
        ]),
        clazz('propitem-editabletxt')
      ]);
    }
  }

  Component restoreState(Component previous) {
    if (previous is EditableText) {
      myState = previous.myState;
    } else {
      myState = new EditableElementState(value);
    }
    return this;
  }
}
