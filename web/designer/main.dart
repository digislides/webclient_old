import 'dart:html';
import 'package:domino/html_view.dart';
import 'package:client/component/designer/designer.dart';
import 'package:client/service/designer/service.dart';
import 'package:client/service/designer/server.dart';

Map<String, String> getUrlParams() {
  Map<String, String> params = new Map<String, String>();
  window.location.search.replaceFirst("?", "").split("&").forEach((e) {
    if (e.contains("=")) {
      List<String> split = e.split("=");
      params[split[0]] = split[1];
    }
  });

  return params;
}

main() async {
  state.program = await service.getProgramById(getUrlParams()['id']);
  registerHtmlView(
    querySelector('body'),
    new Designer(onAction: (String action) async {
      if (action == 'save') {
        String editId = state.editingId;
        state.program =
            await service.saveProgram(state.program.id, state.program);
        state.editingId = editId;
      } else if (action == 'properties') {
        state.overlay = 'properties';
      } else if (action == 'publish') {
        String editId = state.editingId;
        state.program = await service.publish(state.program.id);
        state.editingId = editId;
      }
    }),
  );
}
