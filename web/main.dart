import 'dart:html';
import 'package:domino/html_view.dart';
import 'package:domino/setters.dart';
import 'package:domino_nodes/domino_nodes.dart';
import 'package:client/component/slide_list.dart';
import 'package:client/component/slide_editor.dart';
import 'package:client/component/properties_editor/properties_editor.dart';

import 'package:client/service/data.dart';

class TitleBar implements Component {
  final String name;

  TitleBar(this.name);

  @override
  dynamic build(BuildContext context) {
    return div(
        content: [div(content: name, set: clazz('titlebar-title'))],
        set: [clazz('titlebar')]);
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
            new PagePropBar(state.editingPage),
            div(
                set: [clazz('main-area')],
                content: new Stage(
                  width: state.editingPage.width,
                  height: state.editingPage.height,
                  color: state.editingPage.color,
                  image: state.editingPage.imageId,
                ))
          ]);
}
