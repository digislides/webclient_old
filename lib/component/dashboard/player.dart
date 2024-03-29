part of client.components.dashboard;

class PlayerList implements Component {
  final List<Player> players;

  PlayerList(this.players);


  @override
  dynamic build(BuildContext context) {
    return div([
      clazz('central-area'),
      div([
        clazz('header'),
        div([clazz('title'), 'Players']),
        div([
          clazz('action'),
          '+',
          onClick((_) {
            state.context = 'createPlayer';
          }),
        ]),
      ]),
      div([
        clazz('cards-list'),
        players.map((Player prog) => div([
          clazz('home-card-prog'),
          div([clazz('screenshot')]),
          div([
            clazz('content'),
            div([
              clazz('heading'),
              prog.name,
              onClick((_) {
                html.window
                    .open('/designer/index.html?id=${prog.id}', 'Program');
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
                div([clazz('label'), 'Playing']),
                // TODO
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
                onClick((_) async {
                  state.context =
                  await state.service.duplicateProgram(prog.id);
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
    ]);
  }
}

/// Component used to create a new player
class PlayerCreator implements StatefulComponent {
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
                  state.context = await state.service.createPlayer(model);
                } catch (e) {
                  // TODO
                }
              }),
            ]),
            div([
              clazz('action', 'red'),
              'Close',
              onClick((_) async {
                state.context = await state.service.getPlayers();
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

/// Component used to edit a player
class PlayerEditor implements Component {
  final Player player;

  PlayerEditor(this.player);

  @override
  dynamic build(BuildContext context) {
    // TODO
  }
}