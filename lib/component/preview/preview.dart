import 'dart:html' as html;
import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';
import 'package:client/models/models.dart';
import 'package:domino_nodes/domino_nodes.dart' as dn;

class PageCanvas implements Component {
  Page page;

  PageCanvas(this.page);

  @override
  build(BuildContext context) {
    return div([
      clazz('page'),
      width(page.width),
      height(page.height),
      bgColor(page.color),
      when(page.image != null && page.image.isNotEmpty,
          bgImage('url(${page.image})')),
      style('background-size', page.fit.bgSize),
      style('background-repeat', page.fit.repeat),
      foreach(page.items, (PageItem item) {
        if (item is TextItem) {
          return new Element('pre', [
            item.text,
            clazz('item'),
            dn.width(item.width),
            dn.height(item.height),
            dn.left(item.left),
            dn.top(item.top),
            dn.color(item.font.color),
            dn.fontSize(item.font.size),
            when(item.font.bold, style('font-weight', 'bold')),
            when(item.font.italic, style('font-style', 'italic')),
            when(item.font.underline, style('text-decoration', 'underline')),
          ]);
        } else if (item is ImageItem) {
          return div([
            clazz('item'),
            dn.width(item.width),
            dn.height(item.height),
            dn.left(item.left),
            dn.top(item.top),
            when(item.url != null && item.url.isNotEmpty,
                bgImage('url(${item.url})')),
            style('background-size', item.fit.bgSize),
            style('background-repeat', item.fit.repeat),
          ]);
        }
        // TODO other elements
      }),
    ]);
  }
}
