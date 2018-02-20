import 'dart:html';
import 'package:domino/html_view.dart';
import 'package:domino/setters.dart';
import 'package:domino_nodes/domino_nodes.dart';
import 'package:client/component/slide_list.dart';
import 'package:client/component/slide_editor.dart';

import 'package:client/service/data.dart';

main() async {
  state.program = await service.getProgramById('1');
  state.editingId = state.program.pages.first.id;
  registerHtmlView(
      querySelector('body'),
      (_) => [
            new SlideListComponent(
                state.program.pages, state.editingId, state.selectedIds),
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
