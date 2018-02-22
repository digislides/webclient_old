import 'dart:html' as html;
import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';
import 'package:domino/setters.dart';

import 'package:client/models/models.dart';

import 'package:client/service/data.dart';

abstract class State {}

class _EditableElementState implements State {
  String original;

  Element el;

  bool isEditing = false;

  _EditableElementState(this.original);
}

class EditableText implements Component {
  final String value;

  final Page key;

  _EditableElementState myState;

  EditableText(this.value, this.key) {
    myState = storage.insertIfNotExists(key, new _EditableElementState(value));
  }

  @override
  dynamic build(BuildContext context) {
    if (!myState.isEditing)
      return div(content: value, set: [
        clazz('propitem-editabletxt', 'not-editing'),
        onClick((_) {
          myState.isEditing = true;
        })
      ]);
    else {
      if (myState.el == null) {
        print('h');
        myState.el = textInput(
            set: [
              attr('value', value),
              onBlur((Event e) {
                state.editingPage.name =
                    (e.domElement as html.InputElement).value;
                myState.isEditing = false;
                myState.el = null;
                storage.remove(key);
              })
              /* TODO
          onKeyPress((Event e) {
            final html.KeyboardEvent event = e.domEvent;
            print('t');
            if (event.keyCode == html.KeyCode.ENTER) {
              print('j');
              state.editingPage.name =
                  (event.target as html.InputElement).value;
              myState.isEditing = false;
              myState.el = null;
              storage.remove(key);
            }
          })
          */
            ],
            key: key.id,
            afterInsert:
                ((html.Element node) => node.focus()) as AfterCallback);
      }
      return div(content: myState.el, set: [clazz('propitem-editabletxt')]);
    }
  }
}

class ColorPropEditor implements Component {
  final String color;

  final Function onChange;

  ColorPropEditor(this.color, void onChange(String color))
      : onChange = onChange;

  @override
  dynamic build(BuildContext context) {
    return div(content: [
      div(set: [
        style('background-image', 'url(/img/bgcolor.png)'),
        clazz('icon')
      ]),
      div(set: [bgColor(color), clazz('display')])
    ], set: [
      clazz('propitem-color')
    ]);
  }
}

class _Swatch implements Component {
  final String color;

  const _Swatch(this.color);

  @override
  dynamic build(BuildContext context) {
    return div(set: [width(16), height(16), bgColor(color)]);
  }
}

class Palette implements Component {
  @override
  dynamic build(BuildContext context) {
    return div(content: [
      div(content: [new _Swatch('rgb(0, 0, 0)')]),
      div(),
    ]);
  }
}

class PagePropBar implements Component {
  final Page page;

  PagePropBar(this.page);

  @override
  dynamic build(BuildContext context) {
    return div(content: [
      new EditableText(page.name, page),
      new ColorPropEditor(page.color, (String color) => page.color = color)
    ], set: [
      clazz('propbar')
    ]);
  }
}

List<List<String>> colors = <List<String>>[
  <String>[
    'rgb(0, 0, 0)',
    'rgb(67, 67, 67)',
    'rgb(102, 102, 102)',
    'rgb(153, 153, 153)',
    'rgb(183, 183, 183)',
    'rgb(204, 204, 204)'
  ],
];
