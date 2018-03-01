import 'dart:html' as html;
import 'state.dart';
import 'package:domino/domino.dart';
import 'package:domino_nodes/domino_nodes.dart';

class DurationEditor implements StatefulComponent, Input<int> {
  final int seconds;

  final IntCallBack onInput;

  EditableElementState myState;

  DurationEditor(this.seconds, {this.onInput});

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
      when(myState.isEditing, new _DurationEditor(seconds, onInput: onInput)),
    ]);
  }

  @override
  Component restoreState(Component previous) {
    if (previous is DurationEditor) {
      myState = previous.myState;
    } else {
      myState = new EditableElementState(seconds);
    }
    return this;
  }
}

class _Duration implements State {
  int seconds = 0;

  int minutes = 0;

  int hours = 0;

  int days = 0;

  _Duration.fromDuration(Duration duration) {
    seconds = duration.inSeconds % 60;
    minutes = duration.inMinutes % 60;
    hours = duration.inMinutes % 24;
    days = duration.inDays;
  }

  factory _Duration(int seconds) =>
      new _Duration.fromDuration(new Duration(seconds: seconds));
}

class _DurationEditor implements StatefulComponent {
  final int seconds;

  final IntCallBack onInput;

  EditableElementState<_Duration> myState;

  _DurationEditor(this.seconds, {this.onInput});

  @override
  dynamic build(BuildContext context) {
    return div([
      clazz('prop-dd', 'prop-dur-dd'),
      div([
        clazz('input-row'),
        textInput([
          #seconds,
          afterInsert((Change change) {
            change.node.value = myState.original.seconds.toString();
            change.node.focus();
          }),
        ]),
        span('s'),
      ]),
      div([
        clazz('input-row'),
        textInput([
          #minutes,
          afterInsert((Change change) {
            change.node.value = myState.original.minutes.toString();
          }),
        ]),
        span('m'),
      ]),
      div([
        clazz('input-row'),
        textInput([
          #hours,
          afterInsert((Change change) {
            change.node.value = myState.original.hours.toString();
          }),
        ]),
        span('h'),
      ]),
      div([
        clazz('input-row'),
        textInput([
          #days,
          afterInsert((Change change) {
            change.node.value = myState.original.days.toString();
          }),
        ]),
        span('d'),
      ]),
      div([
        'Ok',
        clazz('action'),
        onClick((Event e) {
          if (onInput != null) {
            int seconds = int.parse(
                (e.getNodeBySymbol(#seconds) as html.InputElement).value,
                onError: (_) => 0);
            int minutes = int.parse(
                (e.getNodeBySymbol(#minutes) as html.InputElement).value,
                onError: (_) => 0);
            int hours = int.parse(
                (e.getNodeBySymbol(#hours) as html.InputElement).value,
                onError: (_) => 0);
            int days = int.parse(
                (e.getNodeBySymbol(#days) as html.InputElement).value,
                onError: (_) => 0);
            int ret = new Duration(
                    seconds: seconds,
                    minutes: minutes,
                    hours: hours,
                    days: days)
                .inSeconds;
            onInput(ret);
          }
        })
      ]),
    ]);
  }

  @override
  Component restoreState(Component previous) {
    if (previous is _DurationEditor) {
      myState = previous.myState;
    } else {
      myState = new EditableElementState(new _Duration(seconds));
      myState.isEditing = true;
    }
    return this;
  }
}
