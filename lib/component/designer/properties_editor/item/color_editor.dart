import 'state.dart';
import 'package:domino/domino.dart';
import 'package:domino_nodes/domino_nodes.dart';

class ColorPropEditor implements StatefulComponent, Input<String> {
  final String color;

  final StringCallBack onInput;

  EditableElementState myState;

  ColorPropEditor(this.color, {this.onInput});

  @override
  dynamic build(BuildContext context) {
    return div([
      clazz('propitem-color'),
      div([
        clazz('propitem-color-icon'),
        onClick((_) {
          myState.isEditing = !myState.isEditing;
        }),
        div([clazz('icon')]),
        div([bgColor(color), clazz('display')]),
      ]),
      when(myState.isEditing, new Palette(color, onInput: onInput)),
    ]);
  }

  Component restoreState(Component previous) {
    if (previous is ColorPropEditor) {
      myState = previous.myState;
    } else {
      myState = new EditableElementState(color);
    }
    return this;
  }
}

class Palette implements Component {
  final String color;

  final StringCallBack onInput;

  Palette(this.color, {this.onInput});

  @override
  dynamic build(BuildContext context) {
    return div([
      clazz('prop-dd', 'palette'),
      div([
        clazz('inputs'),
        div([clazz('value'), bgColor(color)]),
        div([span('r'), textInput(), clazz('input')]),
        div([span('g'), textInput(), clazz('input')]),
        div([span('b'), textInput(), clazz('input')]),
        div([span('a'), textInput(), clazz('input')]),
      ]),
      div([
        _colorsGray
            .map((String color) => new _Swatch(color, onSelected: onInput)),
        clazz('swatch-row')
      ]),
      div([
        _colorsDifferent
            .map((String color) => new _Swatch(color, onSelected: onInput)),
        clazz('swatch-row')
      ]),
      div([
        _colorsShades.map((List<String> colors) => div([
              colors.map(
                  (String color) => new _Swatch(color, onSelected: onInput)),
              clazz('swatch-row')
            ])),
        clazz('swatch-shades')
      ]),
    ]);
  }
}

class _Swatch implements Component {
  final String color;

  final StringCallBack onSelected;

  const _Swatch(this.color, {this.onSelected});

  @override
  dynamic build(BuildContext context) {
    return div([
      clazz('swatch'),
      bgColor(color),
      when(onSelected != null, onClick((_) => onSelected(color)))
    ]);
  }
}

List<String> _colorsGray = <String>[
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
];

List<String> _colorsDifferent = <String>[
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
];

List<List<String>> _colorsShades = <List<String>>[
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
