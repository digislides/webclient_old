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
    return div(content: [
      div(content: [
        div(set: [
          style('background-image', 'url(/img/duration.png)'),
          clazz('icon')
        ]),
        span(content: '${seconds}s', set: [clazz('display')]),
      ], set: [
        clazz('prop-dur-icon')
      ]),
    ], set: [
      clazz('prop-dur')
    ]);
  }
}

class _DurationState implements State {
  int seconds = 0;

  int minutes = 0;

  int hours = 0;

  int days = 0;

  _DurationState.fromDuration(Duration duration) {
    // TODO
  }

  _DurationState.fromSeconds(int seconds) {
    // TODO
  }
}

class _DurationEditor implements Component {
  final String key;

  _DurationState myState;

  _DurationEditor(int seconds, {this.key}) {
    myState = storage.insertIfNotExists(key, new _DurationEditor(seconds));
  }

  @override
  dynamic build(BuildContext context) {
    // TODO
  }
}
