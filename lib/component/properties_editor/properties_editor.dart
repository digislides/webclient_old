import 'dart:html' as html;
import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';
import 'package:domino/setters.dart';

import 'package:client/models/models.dart';

import 'package:client/service/data.dart';

class EditableText implements Component {
  final String value;

  EditableText(this.value);

  @override
  dynamic build(BuildContext context) {
    return div(
        content: textInput(set: [attr('value', value)]),
        set: [clazz('propitem-editabletxt')]);
  }
}

class PagePropBar implements Component {
  final Page page;

  PagePropBar(this.page);

  @override
  dynamic build(BuildContext context) {
    return div(
        content: div(content: [new EditableText(page.name)]),
        set: [clazz('propbar')]);
  }
}
