import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';
import 'package:client/models/models.dart';
import 'package:client/service/data.dart';

import 'item/string_editor.dart';
import 'item/color_editor.dart';
import 'item/duration_editor.dart';

class PagePropBar implements Component {
  final Page page;

  PagePropBar(this.page);

  @override
  dynamic build(BuildContext context) {
    return div([
      clazz('propbar'),
      new EditableText(page.name,
          onInput: (String value) => page.name = value, key: page.id + '.name'),
      new ColorPropEditor(page.color,
          onInput: (String color) => page.color = color,
          key: page.id + '.bgcolor'),
      new DurationEditor(page.duration,
          onInput: (int duration) => page.duration, key: page.id + '.dur'),
    ]);
  }
}
