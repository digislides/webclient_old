import 'dart:html' as html;
import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';
import 'package:client/models/models.dart';
import 'package:client/service/dashboard/service.dart';
import 'package:client/component/properties_editor/item/string_editor.dart';
import 'package:client/component/properties_editor/item/state.dart';

class ProgramsList implements Component {
  final List<Program> programs;

  ProgramsList(this.programs);

  @override
  dynamic build(BuildContext context) {
    return [
      div([
        clazz('header'),
        div([clazz('title'), 'Programs']),
        div([
          clazz('action'),
          '+',
          onClick((_) {
            state.context = 'createProgram';
          }),
        ]),
      ]),
      div([
        clazz('cards-list'),
        foreach(
            programs,
            (Program prog) => div([
                  clazz('home-card-prog'),
                  div([clazz('screenshot')]),
                  div([
                    clazz('content'),
                    div([
                      clazz('heading'),
                      prog.name,
                      onClick((_) {
                        html.window.open(
                            '/designer/index.html?id=${prog.id}', 'Program');
                      })
                    ]),
                    div([
                      div([
                        clazz('info-row'),
                        div([clazz('label'), 'Size']),
                        div([clazz('value'), '${prog.width}x${prog.height}']),
                      ]),
                      div([
                        clazz('info-row'),
                        div([clazz('label'), 'Pages']),
                        div([clazz('value'), '${prog.pages.length}']),
                      ])
                    ]),
                    div([
                      clazz('actions'),
                      div([
                        clazz('action'),
                        bgImage('url(/img/edit.png)'),
                        onClick((_) {
                          state.context = prog;
                        })
                      ]),
                      div([
                        clazz('action'),
                        bgImage('url(/img/copy.png)'),
                        onClick((_) {
                          // TODO
                        })
                      ]),
                      div([
                        clazz('action'),
                        bgImage('url(/img/delete.png)'),
                        onClick((_) async {
                          state.context =
                              await state.service.deleteProgram(prog.id);
                        })
                      ]),
                    ]),
                  ]),
                ])),
      ])
    ];
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

/// Component used to create a new program
class ProgramCreatorComp implements StatefulComponent {
  ProgramCreator model;

  @override
  dynamic build(BuildContext context) {
    return [
      div([
        clazz('header'),
        div([clazz('title'), 'Create program', style('text-align', 'center')]),
      ]),
      div([
        clazz('content'),
        div([
          clazz('form', 'center'),
          div([
            clazz('form-row'),
            div([clazz('label'), 'Name']),
            new EditableText(model.name,
                key: 'name', onInput: (String v) => model.name = v),
          ]),
          div([
            clazz('form-row'),
            div([clazz('label'), 'Width']),
            new EditableText(model.width,
                key: 'width',
                onInput: (String v) =>
                    model.width = int.parse(v, onError: (_) => model.width)),
          ]),
          div([
            clazz('form-row'),
            div([clazz('label'), 'Height']),
            new EditableText(model.height,
                key: 'height',
                onInput: (String v) =>
                    model.height = int.parse(v, onError: (_) => model.height)),
          ]),
          div([
            clazz('actions'),
            div([
              clazz('action', 'blue'),
              'Create',
              onClick((_) async {
                try {
                  state.context = await state.service.createPrograms(model);
                } catch (e) {
                  // TODO
                }
              }),
            ]),
            div([
              clazz('action', 'red'),
              'Close',
              onClick((_) async {
                state.context = await state.service.getPrograms();
              })
            ])
          ]),
        ]),
      ]),
    ];
  }

  @override
  Component restoreState(Component previous) {
    if (previous is ProgramCreatorComp) {
      model = previous.model;
    } else {
      model = new ProgramCreator()
        ..name = 'Program'
        ..width = 300
        ..height = 150;
    }
    return null;
  }
}

class ProgramEditor implements StatefulComponent {
  final Program p;

  ProgramCreator model;

  ProgramEditor(this.p);

  @override
  dynamic build(BuildContext context) {
    return [
      div([
        clazz('header'),
        div([clazz('title'), 'Edit program', style('text-align', 'center')]),
      ]),
      div([
        clazz('content'),
        div([
          clazz('form', 'center'),
          div([
            clazz('form-row'),
            div([clazz('label'), 'Name']),
            new EditableText(model.name, key: 'prog-edit-name',
                onInput: (String v) {
              model.name = v;
              print(v);
            }),
          ]),
          div([
            clazz('form-row'),
            div([clazz('label'), 'Width']),
            new EditableText(model.width,
                key: 'prog-edit-width',
                onInput: (String v) =>
                    model.width = int.parse(v, onError: (_) => model.width)),
          ]),
          div([
            clazz('form-row'),
            div([clazz('label'), 'Height']),
            new EditableText(model.height,
                key: 'prog-edit-height',
                onInput: (String v) =>
                    model.height = int.parse(v, onError: (_) => model.height)),
          ]),
          div([
            clazz('actions'),
            div([
              clazz('action', 'blue'),
              'Update',
              onClick((_) async {
                try {
                  state.context =
                      await state.service.editProgram(p.id, model);
                } catch (e) {
                  // TODO
                }
              }),
            ]),
            div([
              clazz('action', 'red'),
              'Close',
              onClick((_) async {
                state.context = await state.service.getPrograms();
              })
            ])
          ]),
        ]),
      ]),
    ];
  }

  @override
  Component restoreState(Component previous) {
    if (previous is ProgramEditor) {
      model = previous.model;
    } else {
      model = new ProgramCreator()
        ..name = p.name
        ..width = p.width
        ..height = p.height;
    }
    return null;
  }
}

/// Component used to create a new player
class PlayerCreator implements Component {
  @override
  dynamic build(BuildContext context) {
    // TODO create player
  }
}

/// Component used to edit a player
class PlayerEditor implements Component {
  final Player player;

  PlayerEditor(this.player);

  @override
  dynamic build(BuildContext context) {
    // TODO
  }
}

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

class Dashboard implements Component {
  @override
  dynamic build(BuildContext context) {
    return [
      new TitleBar(),
      div([
        clazz('main-area'),
        when(state.context is List<Program>,
            () => new ProgramsList(state.context)),
        when(
            state.context is List<Player>, () => new PlayerList(state.context)),
        when(state.context is Program, () => new ProgramEditor(state.context)),
        when(state.context is Player, () => new PlayerEditor(state.context)),
        when(state.context == 'createProgram', () => new ProgramCreatorComp()),
        when(state.context == 'createPlayer', () => new PlayerCreator()),
        when(state.context is HomeInfo, () => new Home(state.context)),
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
