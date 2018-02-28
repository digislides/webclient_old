import 'package:domino/html_view.dart';
import 'package:domino_nodes/domino_nodes.dart';
import 'package:client/component/slide_list.dart';
import 'package:client/component/slide_editor.dart';
import 'package:client/component/properties_editor/page_editor.dart';
import 'package:client/models/models.dart';

import 'package:client/service/data.dart';

class TitleBar implements Component {
  final String name;

  final onSave;

  TitleBar(this.name, {this.onSave});

  @override
  dynamic build(BuildContext context) {
    return div([
      clazz('titlebar'),
      div([name, clazz('titlebar-title')]),
      div([
        clazz('actions'),
        div([clazz('action'), 'Properties']),
        div([clazz('action'), 'Save', onClick((_) => onSave())]),
        div([clazz('action'), 'Publish']),
      ]),
    ]);
  }
}

class ProgramEditor implements Component {
  final onSave;

  ProgramEditor({this.onSave});

  @override
  build(BuildContext context) => [
        new TitleBar(state.program.name, onSave: onSave),
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
            )
          ])
        ])
      ];
}
