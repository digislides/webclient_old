import 'dart:html';
import 'package:domino/html_view.dart';
import 'package:client/component/slide_list.dart';

import 'package:client/service/data.dart';

main() async {
  state.program = await service.getProgramById('1');
  state.editingPage = '1';
  registerHtmlView(
      querySelector('body'),
      (_) => [
            new SlideListComponent(
                state.program.pages, state.editingPage, state.selectedIds)
          ]);
}
