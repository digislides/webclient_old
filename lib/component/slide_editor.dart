import 'dart:html' as html;
import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';
import 'package:domino/setters.dart';

import 'package:client/models/models.dart';

import 'package:client/service/data.dart';

class Stage implements Component {
  final int width;

  final int height;

  final String color;

  final String image;

  const Stage({this.width, this.height, this.color, this.image});

  @override
  dynamic build(BuildContext context) {
    // TODO
    return div(content: [
      div(content: [
        div(content: [], set: [
          clazz('stage'),
          style('width', '${width}px'),
          style('height', '${height}px'),
          style('background-color', color),
        ])
      ], set: [
        clazz('stage-canvas'),
        style('width', '${width + 300}px'),
        style('height', '${height + 300}px')
      ])
    ], set: [
      clazz('stage-viewport')
    ]);
  }
}
