library client.components.dashboard;

import 'dart:html' as html;
import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';
import 'package:client/models/models.dart';
import 'package:client/service/dashboard/service.dart';
import 'package:client/component/designer/properties_editor/item/string_editor.dart';
import 'package:client/component/designer/properties_editor/item/state.dart';

part 'program.dart';
part 'player.dart';

class HomeInfo {
  List<Program> programs;

  List<Player> players;
}

class Home implements Component {
  final HomeInfo info;

  Home(this.info);

  @override
  build(BuildContext context) {}
}

class Sidebar implements Component {
  @override
  build(BuildContext context) => div([
        clazz('sidebar'),
        div([
          clazz('sidebar-item'),
          'Front page',
          clazzIf(state.context is HomeInfo, 'selected'),
          // TODO
          onClick(
              (_) async => state.context = await state.service.getPrograms()),
        ]),
        div([
          clazz('sidebar-item'),
          'Programs',
          clazzIf(state.context is List<Program>, 'selected'),
          // TODO
          onClick(
              (_) async => state.context = await state.service.getPrograms()),
        ]),
        div([
          clazz('sidebar-item'),
          'Players',
          clazzIf(state.context is List<Player>, 'selected'),
          // TODO
          onClick(
              (_) async => state.context = await state.service.getPlayers()),
        ]),
      ]);
}

class Dashboard implements Component {
  @override
  dynamic build(BuildContext context) {
    return [
      new TitleBar(),
      div([
        clazz('main-area'),
        when(state.context is List<Program>,
            () => [new Sidebar(), new ProgramsList(state.context)]),
        when(state.context is List<Player>,
            () => [new Sidebar(), new PlayerList(state.context)]),
        when(state.context is Program, () => new ProgramEditor(state.context)),
        when(state.context is Player, () => new PlayerEditor(state.context)),
        when(state.context == 'createProgram', () => new ProgramCreatorComp()),
        when(state.context == 'createPlayer', () => new PlayerCreator()),
        when(state.context is HomeInfo,
            () => [new Sidebar(), new Home(state.context)]),
      ]),
    ];
  }
}

class TitleBar implements Component {
  TitleBar();

  @override
  dynamic build(BuildContext context) {
    return div([
      div(['DigiSlides', clazz('titlebar-title')]),
      clazz('titlebar'),
    ]);
  }
}
