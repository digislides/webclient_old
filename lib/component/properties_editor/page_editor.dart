import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';
import 'package:client/models/models.dart';

import 'item/string_editor.dart';
import 'item/color_editor.dart';
import 'item/duration_editor.dart';
import 'item/image_editor.dart';

class PropBar implements Component {
  final dynamic selected;

  PropBar(this.selected);

  @override
  dynamic build(BuildContext context) {
    return div([
      clazz('propbar'),
      #propbar,
      when(selected is Page, () => new PagePropBar(selected)),
      when(selected is TextItem, () => new TextPropBar(selected)),
      when(selected is ImageItem, () => new ImagePropBar(selected)),
    ]);
  }
}

class PagePropBar implements Component {
  final Page page;

  PagePropBar(this.page);

  @override
  build(BuildContext context) => [
        new EditableText(page.name,
            onInput: (String value) => page.name = value,
            key: page.id + '.name',
            rootClass: 'with-border'),
        new ColorPropEditor(page.color,
            onInput: (String color) => page.color = color),
        new DurationEditor(page.duration,
            onInput: (int duration) => page.duration = duration),
        new ImageEditor(page.image)
      ];
}

class TextPropBar implements Component {
  final TextItem item;

  TextPropBar(this.item);

  @override
  build(BuildContext context) => [
        new ItemPositionProperties(item),
        new ColorPropEditor(item.font.color,
            onInput: (String color) => item.font.color = color),
      ];
}

class ImagePropBar implements Component {
  final ImageItem item;

  ImagePropBar(this.item);

  @override
  build(BuildContext context) => [
        new ItemPositionProperties(item),
        new ImageEditor(item.url),
      ];
}

class ItemPositionProperties implements Component {
  final PageItem item;

  ItemPositionProperties(this.item);

  @override
  build(BuildContext context) {
    return [
      new EditableText(item.name,
          rootClass: ['with-border'],
          onInput: (String value) => item.name = value,
          key: 'name'),
      div([
        clazz('pos-holder'),
        icon('/img/width.png', rootClass: 'icon'),
        new EditableText(item.width.toString(),
            key: 'width',
            rootClass: 'text-align-right',
            onInput: (String value) =>
                item.width = int.parse(value, onError: (_) => item.width))
      ]),
      div([
        clazz('pos-holder'),
        icon('/img/height.png', rootClass: 'icon'),
        new EditableText(item.height.toString(),
            key: 'height',
            rootClass: 'text-align-right',
            onInput: (String value) =>
                item.height = int.parse(value, onError: (_) => item.height))
      ]),
      div([
        clazz('pos-holder'),
        icon('/img/left.png', rootClass: 'icon'),
        new EditableText(item.left.toString(),
            key: 'left',
            rootClass: 'text-align-right',
            onInput: (String value) =>
                item.left = int.parse(value, onError: (_) => item.left))
      ]),
      div([
        clazz('pos-holder'),
        icon('/img/top.png', rootClass: 'icon'),
        new EditableText(item.top.toString(),
            key: 'top',
            rootClass: 'text-align-right',
            onInput: (String value) =>
                item.top = int.parse(value, onError: (_) => item.top))
      ]),
    ];
  }
}

Element icon(String src, {dynamic rootClass}) => div([
      #icon,
      bgImage('url(${src})'),
      style('background-size', 'contain'),
      style('background-repeat', 'no-repeat'),
      style('background-position', 'center'),
      width(12),
      height(12),
      style('display', 'inline-block'),
      style('flex-shrink', '0'),
      clazz(rootClass),
    ]);
