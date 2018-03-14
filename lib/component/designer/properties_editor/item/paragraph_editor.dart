import 'dart:html' as html;
import 'state.dart';
import 'package:domino/domino.dart';
import 'package:domino_nodes/domino_nodes.dart';

class ParagraphEditor implements StatefulComponent, Input<String> {
  final value;

  final String key;

  final StringCallBack onInput;

  final rootClass;

  EditableElementState myState;

  ParagraphEditor(this.value, {this.key: 'key', this.onInput, this.rootClass});

  @override
  dynamic build(BuildContext context) {
    if (!myState.isEditing)
      return div([
        clazz('propitem-parag', rootClass),
        div([
          clazz('disp'),
          value.toString(),
          onClick((_) {
            myState.isEditing = true;
          }),
        ]),
      ]);
    else {
      return div([
        clazz('propitem-parag', rootClass),
        div([
          clazz('disp'),
          value.toString(),
          onClick((_) {
            myState.isEditing = false;
          }),
        ]),
        div([
          clazz('prop-dd', 'parag-dd'),
          new Element('textarea', [
            new Symbol(key + 'Inp'),
            when(key != null, new Symbol(key)),
            afterInsert((Change change) {
              change.node.value = value.toString();
              change.node.focus();
            }),
            onBlur((Event e) {
              if (myState.isEditing && onInput != null) {
                onInput((e.element as html.TextAreaElement).value);
              }
              myState.isEditing = false;
            }),
            onKeyDown((Event e) {
              final html.KeyboardEvent event = e.event;
              if (event.keyCode == html.KeyCode.ESC) {
                myState.isEditing = false;
              }
            }),
          ]),
        ]),
      ]);
    }
  }

  Component restoreState(Component previous) {
    if (previous is ParagraphEditor) {
      myState = previous.myState;
    } else {
      myState = new EditableElementState(value);
    }
    return this;
  }
}
