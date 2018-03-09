import 'dart:html';
import 'package:domino/html_view.dart';
import 'package:client/component/program_editor.dart';
import 'package:client/service/designer/service.dart';
import 'package:client/service/designer/mock.dart';

main() async {
  state.program = await service.getProgramById('1');
  registerHtmlView(querySelector('body'),
      new ProgramEditor(onAction: (String action) async {
    if (action == 'save') {
      String editId = state.editingId;
      state.program =
          await service.saveProgram(state.program.id, state.program);
      state.editingId = editId;
    } else if (action == 'properties') {
      state.overlay = 'properties';
    }
  }));
}
