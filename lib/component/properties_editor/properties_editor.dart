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
      foreach(),
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
    'rgb(204, 204, 204)',
    'rgb(217, 217, 217)',
    'rgb(239, 239, 239)',
    'rgb(243, 243, 243)',
    'rgb(255, 255, 255)',
  ],
  [
    'rgb(152, 0, 0)',
    'rgb(255, 0, 0)',
    'rgb(255, 153, 0)',
    'rgb(255, 255, 0)',
    'rgb(0, 255, 0)',
    'rgb(0, 255, 255)',
    'rgb(74, 134, 232)',
    'rgb(0, 0, 255)',
    'rgb(153, 0, 255)',
    'rgb(255, 0, 255)',
  ],
  [
    'rgb(230, 184, 175)',
    'rgb(244, 204, 204)',
    'rgb(252, 229, 205)',
    'rgb(255, 242, 204)',
    'rgb(217, 234, 211)',
    'rgb(208, 224, 227)',
    'rgb(201, 218, 248)',
    'rgb(207, 226, 243)',
    'rgb(217, 210, 233)',
    'rgb(234, 209, 220)',
  ],
  [
    'rgb(221, 126, 107)',
    'rgb(234, 153, 153)',
    'rgb(249, 203, 156)',
    'rgb(255, 229, 153)',
    'rgb(182, 215, 168)',
    'rgb(162, 196, 201)',
    'rgb(164, 194, 244)',
    'rgb(159, 197, 232)',
    'rgb(180, 167, 214)',
    'rgb(213, 166, 189)',
  ],
  [
    'rgb(204, 65, 37)',
    'rgb(224, 102, 102)',
    'rgb(246, 178, 107)',
    'rgb(255, 217, 102)',
    'rgb(147, 196, 125)',
    'rgb(118, 165, 175)',
    'rgb(109, 158, 235)',
    'rgb(111, 168, 220)',
    'rgb(142, 124, 195)',
    'rgb(194, 123, 160)',
  ],
  [
    'rgb(166, 28, 0)',
    'rgb(204, 0, 0)',
    'rgb(230, 145, 56)',
    'rgb(241, 194, 50)',
    'rgb(106, 168, 79)',
    'rgb(69, 129, 142)',
    'rgb(60, 120, 216)',
    'rgb(61, 133, 198)',
    'rgb(103, 78, 167)',
    'rgb(166, 77, 121)',
  ],
  [
    'rgb(133, 32, 12)',
    'rgb(153, 0, 0)',
    'rgb(180, 95, 6)',
    'rgb(191, 144, 0)',
    'rgb(56, 118, 29)',
    'rgb(19, 79, 92)',
    'rgb(17, 85, 204)',
    'rgb(11, 83, 148)',
    'rgb(53, 28, 117)',
    'rgb(116, 27, 71)',
  ],
  [
    'rgb(91, 15, 0)',
    'rgb(102, 0, 0)',
    'rgb(120, 63, 4)',
    'rgb(127, 96, 0)',
    'rgb(39, 78, 19)',
    'rgb(12, 52, 61)',
    'rgb(28, 69, 135)',
    'rgb(7, 55, 99)',
    'rgb(32, 18, 77)',
    'rgb(76, 17, 48)',
  ],
];
