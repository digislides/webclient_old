import 'state.dart';
import 'package:domino/domino.dart';
import 'package:domino_nodes/domino_nodes.dart';
import 'package:client/models/models.dart';

class CheckableIconButton implements Component, Input<bool> {
  final bool checked;

  final String icon;

  final BoolCallBack onInput;

  CheckableIconButton(this.icon, this.checked, {this.onInput});

  @override
  dynamic build(BuildContext context) {
    return div([
      clazz('propitem-icon'),
      clazzIf(checked, 'selected'),
      div([
        clazz('icon'),
        bgImage(icon),
        onClick((_) {
          onInput(!checked);
        }),
      ]),
    ]);
  }
}

class FontEditor implements StatefulComponent, Input<String> {
  final FontProperties font;

  final StringCallBack onInput;

  EditableElementState myState;

  FontEditor(this.font, {this.onInput});

  @override
  dynamic build(BuildContext context) {
    return div([
      clazz('propitem-color'),
      div([
        clazz('propitem-color-icon'),
        onClick((_) {
          myState.isEditing = !myState.isEditing;
        }),
        div([clazz('icon')]),
      ]),
      when(
          myState.isEditing,
          () => div([
                // TODO size
                // TODO align
                // TODO color
                // TODO bold
                // TODO italic
                // TODO underline
                // TODO lineThrough
              ])),
    ]);
  }

  Component restoreState(Component previous) {
    if (previous is FontEditor) {
      myState = previous.myState;
    } else {
      myState = new EditableElementState(color);
    }
    return this;
  }
}
