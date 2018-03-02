import 'dart:html';
import 'dart:async';
import 'package:domino/html_view.dart';
import 'package:client/component/preview/preview.dart';
import 'package:client/service/preview/service.dart';
import 'package:client/service/preview/mock.dart';

void startLoop() {
  void runNextPage() {
    // TODO calendar schedule
    // TODO weather schedule

    state.page++;
    state.page = state.page % state.program.pages.length;

    state.view?.invalidate();
    state.timer = new Timer(
        new Duration(seconds: state.program.pages[state.page].duration),
        runNextPage);
  }
  state.page = 0;
  state.timer = new Timer(
      new Duration(seconds: state.program.pages.first.duration), runNextPage);
}

main() async {
  state.program = await service.getProgramById('1');
  startLoop();
  state.view = registerHtmlView(
      querySelector('body'), (_) => new PageCanvas(state.program.pages[state.page]));
}
