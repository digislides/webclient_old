import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';
import 'package:domino/setters.dart';
import 'package:client/models/models.dart';
import 'package:client/service/data.dart';

class ProgramsList implements Component {
  final List<Program> programs;

  ProgramsList(this.programs);

  @override
  dynamic build(BuildContext context) {
    return div(content: [
      div(),
      foreach(
          programs,
          (Program prog) => div(content: [
                div(content: prog.name, set: [
                  onClick((_) {
                    // TODO open program
                  })
                ]),
                div(content: [
                  div(content: [
                    div(content: 'Size: '),
                    div(content: '${prog.width}x${prog.height}'),
                  ]),
                  div(content: [
                    div(content: '# pages: '),
                    div(content: '${prog.pages.length}'),
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
    return div(content: [
      div(),
      foreach(
          players,
          (Player player) => div(content: [
                div(content: player.name, set: [
                  onClick((_) {
                    // TODO open program
                  })
                ]),
                div(content: []),
                // TODO delete menu
                // TODO duplicate menu
              ])),
    ]);
  }
}
