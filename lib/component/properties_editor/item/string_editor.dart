import 'dart:html' as html;
import 'state.dart';
import 'package:domino/domino.dart';
import 'package:domino_nodes/domino_nodes.dart';

class EditableText implements StatefulComponent, Input<String> {
  final value;

  final String key;

  final StringCallBack onInput;

  final rootClass;

  EditableElementState myState;

  EditableText(this.value, {this.key, this.onInput, this.rootClass});

  @override
  dynamic build(BuildContext context) {
    if (!myState.isEditing)
      return div([
        clazz('propitem-editabletxt', 'not-editing', rootClass),
        when(key != null, new Symbol(key)),
        value.toString(),
        onClick((_) {
          myState.isEditing = true;
          myState.isStartingEditing = true;
        }),
      ]);
    else {
      bool isStartingEditing = myState.isStartingEditing;
      myState.isStartingEditing = false;
      return div([
        clazz('propitem-editabletxt', rootClass),
        when(key != null, new Symbol(key)),
        textInput([
          when(isStartingEditing, attr('value', value.toString())),
          when(key != null, new Symbol(key)),
          afterInsert((Change change) => change.node.focus()),
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
        ]),
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
