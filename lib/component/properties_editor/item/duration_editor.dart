import 'state.dart';
import 'package:domino/domino.dart';
import 'package:domino_nodes/domino_nodes.dart';
import 'package:client/service/data.dart';

class DurationEditor implements Component, Input<int> {
  final int seconds;

  final String key;

  final IntCallBack onInput;

  EditableElementState myState;

  DurationEditor(this.seconds, {this.key, this.onInput}) {
    myState = storage.insertIfNotExists(key, new EditableElementState(seconds));
  }

  @override
  dynamic build(BuildContext context) {
    // TODO
    return div([
      clazz('prop-dur'),
      div([
        div([
          style('background-image', 'url(/img/duration.png)'),
          clazz('icon')
        ]),
        span(['${seconds}s', clazz('display')]),
        clazz('prop-dur-icon'),
        onClick((_) {
          myState.isEditing = !myState.isEditing;
        })
      ]),
      when(myState.isEditing, new _DurationEditor(seconds)),
    ]);
  }
}

class _DurationState implements State {
  int seconds = 0;

  int minutes = 0;

  int hours = 0;

  int days = 0;

  _DurationState.fromDuration(Duration duration) {
    seconds = duration.inSeconds % 60;
    minutes = duration.inMinutes % 60;
    hours = duration.inMinutes % 24;
    days = duration.inDays;
  }

  factory _DurationState(int seconds) =>
      new _DurationState.fromDuration(new Duration(seconds: seconds));
}

class _DurationEditor implements Component {
  final String key;

  _DurationState myState;

  _DurationEditor(int seconds, {this.key}) {
    myState = storage.insertIfNotExists(key, new _DurationState(seconds));
  }

  @override
  dynamic build(BuildContext context) {
    return div([
      clazz('dur-'),
      div([textInput(), span('s'), clazz('input-row')]),
      div([textInput(), span('m'), clazz('input-row')]),
      div([textInput(), span('h'), clazz('input-row')]),
      div([textInput(), span('d'), clazz('input-row')]),
    ]);
  }
}
