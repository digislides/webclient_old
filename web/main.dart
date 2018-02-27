import 'dart:html';
import 'package:domino/html_view.dart';
import 'package:domino_nodes/domino_nodes.dart';
import 'package:client/component/slide_list.dart';
import 'package:client/component/slide_editor.dart';
import 'package:client/component/properties_editor/page_editor.dart';
import 'package:client/models/models.dart';

import 'package:client/service/data.dart';

class TitleBar implements Component {
  final String name;

  TitleBar(this.name);

  @override
  dynamic build(BuildContext context) {
    return div([
      clazz('titlebar'),
      div([name, clazz('titlebar-title')]),
    ]);
  }
}

main() async {
  state.program = await service.getProgramById('1');
  state.editingId = state.program.pages.first.id;
  registerHtmlView(
      querySelector('body'),
      (_) => [
            new TitleBar(state.program.name),
            new SlideListComponent(
                state.program.pages, state.editingId, state.selectedIds),
            new PropBar(state.selectedItem != null
                ? state.selectedItem
                : state.editingPage),
            div([
              clazz('main-area'),
              new ItemAdder(onAdd: (PageItem item) {
                if(state.editingPage != null) {
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
          ]);
}
