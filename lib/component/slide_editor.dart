import 'dart:html' as html;
import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';
import 'package:client/models/models.dart';

class Stage implements Component {
  final int width;

  final int height;

  final String color;

  final String image;

  const Stage({this.width, this.height, this.color, this.image});

  @override
  dynamic build(BuildContext context) {
    // TODO
    return div([
      clazz('stage-viewport'),
      div([
        clazz('stage-canvas'),
        style('width', '${width + 300}px'),
        style('height', '${height + 300}px'),
        div([
          clazz('stage'),
          style('width', '${width}px'),
          style('height', '${height}px'),
          bgColor(color),
          when(image != null && image.isNotEmpty, bgImage('url(${image})')),
        ]),
      ]),
    ]);
  }
}
