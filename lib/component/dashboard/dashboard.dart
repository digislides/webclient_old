import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';
import 'package:client/models/models.dart';

class ProgramsList implements Component {
  final List<Program> programs;

  ProgramsList(this.programs);

  @override
  dynamic build(BuildContext context) {
    return div([
      div(),
      foreach(
          programs,
          (Program prog) => div([
                div([
                  prog.name,
                  onClick((_) {
                    // TODO open program
                  })
                ]),
                div([
                  div([
                    div('Size: '),
                    div('${prog.width}x${prog.height}'),
                  ]),
                  div([
                    div('# pages: '),
                    div('${prog.pages.length}'),
                  ])
                ]),
                // TODO delete menu
                // TODO duplicate menu
              ])),
    ]);
  }
}

class PlayerList implements Component {
  final List<Player> players;

  PlayerList(this.players);

  @override
  dynamic build(BuildContext context) {
    return div([
      div(),
      foreach(
          players,
          (Player player) => div([
                div([
                  player.name,
                  onClick((_) {
                    // TODO open program
                  })
                ]),
                div([]),
                // TODO delete menu
                // TODO duplicate menu
              ])),
    ]);
  }
}

/// Component used to create a new player
class PlayerCreator implements Component {
  @override
  dynamic build(BuildContext context) {
    // TODO create player
  }
}

/// Component used to create a new program
class ProgramCreator implements Component {
  @override
  dynamic build(BuildContext context) {
    return div([]);
  }
}

/// Component used to edit a player
class PlayerEditor implements Component {
  @override
  dynamic build(BuildContext context) {}
}

class Dashboard implements Component {
  @override
  dynamic build(BuildContext context) {
    return [
      new TitleBar(),
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
