import 'package:domino/html_view.dart';
import 'package:domino_nodes/domino_nodes.dart';
import 'package:client/component/slide_list.dart';
import 'package:client/component/slide_editor.dart';
import 'package:client/component/properties_editor/page_editor.dart';
import 'package:client/models/models.dart';
import 'package:client/component/properties_editor/item/string_editor.dart';
import 'package:client/component/properties_editor/item/state.dart';

import 'package:client/service/data.dart';

class TitleBar implements Component {
  final String name;

  final ValueCallBack<String> onAction;

  TitleBar(this.name, {this.onAction});

  @override
  dynamic build(BuildContext context) {
    return div([
      clazz('titlebar'),
      div([name, clazz('titlebar-title')]),
      div([
        clazz('actions'),
        div([
          clazz('action'),
          'Properties',
          onClick((_) => onAction('properties'))
        ]),
        div([clazz('action'), 'Save', onClick((_) => onAction('save'))]),
        div([clazz('action'), 'Publish', onClick((_) => onAction('publish'))]),
      ]),
    ]);
  }
}

class ProgramEditor implements Component {
  final ValueCallBack<String> onAction;

  ProgramEditor({this.onAction});

  @override
  build(BuildContext context) => [
        new TitleBar(state.program.name, onAction: onAction),
        new SlideListComponent(
            state.program.pages, state.editingId, state.selectedIds),
        new PropBar(state.selectedItem != null
            ? state.selectedItem
            : state.editingPage),
        div([
          clazz('main-area'),
          new ItemAdder(onAdd: (PageItem item) {
            if (state.editingPage != null) {
              item.width = state.editingPage.width;
              item.height = state.editingPage.height;
              state.editingPage.items.add(item);
            }
          }),
          div([
            clazz('draw-area'),
            new Stage(
              width: state.editingPage.width,
              height: state.editingPage.height,
              color: state.editingPage.color,
              image: state.editingPage.image,
              fit: state.editingPage.fit,
              items: state.editingPage.items,
              selectedItem: state.selectedItem,
              onSelect: (item) => state.selectedItem = item,
              onDeleteItem: (item) {
                state.deleteItem(item);
              },
            )
          ])
        ]),
        when(state.overlay == 'properties',
            new ProgramPropertiesEditor(state.program)),
      ];
}

class _ProgramPropertiesState {
  int width;

  int height;
}

class ProgramPropertiesEditor implements StatefulComponent {
  final Program program;

  _ProgramPropertiesState myState;

  ProgramPropertiesEditor(this.program);

  @override
  build(BuildContext context) {
    return div([
      clazz('overlay'),
      div([clazz('header'), 'Edit Program properties']),
      div([
        clazz('content'),
        div([
          clazz('form', 'center'),
          div([
            clazz('form-row'),
            div([clazz('label'), 'Width']),
            new EditableText(myState.width,
                key: 'width',
                onInput: (String v) => myState.width =
                    int.parse(v, onError: (_) => program.width)),
            when(myState.width != program.width, span('*')),
          ]),
          div([
            clazz('form-row'),
            div([clazz('label'), 'Height']),
            new EditableText(myState.height,
                key: 'height',
                onInput: (String v) => myState.height =
                    int.parse(v, onError: (_) => program.height)),
            when(myState.height != program.height, span('*')),
          ]),
          div([
            clazz('actions'),
            div([
              clazz('action', 'blue'),
              'Update',
              onClick((_) {
                program.width = myState.width;
                program.height = myState.height;
              }),
            ]),
            div([
              clazz('action', 'red'),
              'Close',
              onClick((_) => state.overlay = null)
            ])
          ]),
        ]),
      ]),
    ]);
  }

  @override
  Component restoreState(Component previous) {
    if (previous is ProgramPropertiesEditor) {
      myState = previous.myState;
    } else {
      myState = new _ProgramPropertiesState()
        ..width = program.width
        ..height = program.height;
    }
    return null;
  }
}
