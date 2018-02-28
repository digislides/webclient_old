import 'dart:html';
import 'package:domino/html_view.dart';
import 'package:client/component/program_editor.dart';
import 'package:client/service/data.dart';
import 'package:client/service/mock.dart';

main() async {
  state.program = await service.getProgramById('1');
  registerHtmlView(querySelector('body'), new ProgramEditor());
}
