import 'dart:html' as html;
import 'properties_editor/item/state.dart';
import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';
import 'package:client/models/models.dart';
import 'package:domino_nodes/domino_nodes.dart' as dn;
import 'dart:math';

class _State {
  Point<num> moveStart;
  Point<num> move;
}

class Stage implements StatefulComponent {
  final int width;

  final int height;

  final String color;

  final ImageFit fit;

  final String image;

  final List<PageItem> items;

  final PageItem selectedItem;

  final ValueCallBack<PageItem> onSelect;

  _State state;

  Stage(
      {this.width,
      this.height,
      this.color,
      this.image,
      this.fit,
      this.items: const [],
      this.selectedItem,
      this.onSelect});

  @override
  dynamic build(BuildContext context) {
    // TODO
    return div([
      clazz('stage-viewport'),
      onClick((event) {
        onSelect(null);
        event.stopImmediatePropagation();
      }),
      div([
        clazz('stage-canvas'),
        style('width', '${width + 300}px'),
        style('height', '${height + 300}px'),
        attr('tabIndex', '0'),
        when(
            selectedItem != null &&
                state.moveStart != null &&
                state.move != null,
            () => [
                  new MoveShow(new Rectangle(
                      state.move.x - state.moveStart.x,
                      state.move.y - state.moveStart.y,
                      selectedItem.width,
                      selectedItem.height)),
                  onMouseUp((Event event) {
                    selectedItem.left = state.move.x - state.moveStart.x - 150;
                    selectedItem.top = state.move.y - state.moveStart.y - 150;
                    state.moveStart = null;
                    state.move = null;
                  }),
                ]),
        onMouseOut((Event event) {
          state.moveStart = null;
          state.move = null;
        }),
        onMouseUp((Event event) {
          state.moveStart = null;
          state.move = null;
        }),
        onKeyDown((Event event) {
          print('here');
          html.KeyboardEvent e = event.event;
          if (e.keyCode == html.KeyCode.ESC) {
            state.moveStart = null;
            state.move = null;
          }
        }),
        when(selectedItem != null && state.moveStart != null,
            onMouseMove((Event event) {
          html.MouseEvent e = event.event;
          if (state.moveStart != null) {
            state.move = e.offset;
          }
        })),
        div([
          clazz('stage'),
          style('width', '${width}px'),
          style('height', '${height}px'),
          bgColor(color),
          when(image != null && image.isNotEmpty, bgImage('url(${image})')),
          style('background-size', fit.bgSize),
          style('background-repeat', fit.repeat),
          when(selectedItem != null && state.moveStart != null,
              style('pointer-events', 'none')),
          foreach(items, (PageItem item) {
            if (item is TextItem) {
              return div([
                item.text,
                clazz('item'),
                onClick((event) {
                  onSelect(item);
                  event.stopImmediatePropagation();
                }),
                dn.width(item.width),
                dn.height(item.height),
                dn.left(item.left),
                dn.top(item.top),
                dn.color(item.font.color),
                dn.fontSize(item.font.size),
              ]);
            } else if (item is ImageItem) {
              return div([
                clazz('item'),
                onClick((event) {
                  onSelect(item);
                  event.stopImmediatePropagation();
                }),
                dn.width(item.width),
                dn.height(item.height),
                dn.left(item.left),
                dn.top(item.top),
                when(item.url != null && item.url.isNotEmpty,
                    bgImage('url(${item.url})')),
                style('background-size', fit.bgSize),
                style('background-repeat', fit.repeat),
              ]);
            }
            // TODO other elements
          }),
          when(
              selectedItem != null,
              () => new Anchors(selectedItem.rect, onMove: (Point move) {
                    state.moveStart = move;
                    if (state.moveStart == null) state.move == null;
                  })),
        ]),
      ]),
    ]);
  }

  @override
  Component restoreState(Component previous) {
    if (previous is Stage) {
      state = previous.state;
    } else {
      state = new _State();
    }
    return this;
  }
}

class MoveShow implements Component {
  final Rectangle<int> box;

  MoveShow(this.box);

  @override
  build(BuildContext context) => div([
        clazz('move-show'),
        left(box.left),
        top(box.top),
        width(box.width),
        height(box.height),
      ]);
}

class Anchors implements Component {
  final Rectangle<int> box;

  final ValueCallBack<Point<num>> onMove;

  Anchors(this.box, {this.onMove});

  @override
  build(BuildContext context) {
    return [
      div([
        clazz('anchors'),
        left(box.left),
        top(box.top),
        width(box.width),
        height(box.height),
        onMouseDown((Event event) {
          onMove((event.event as html.MouseEvent).offset);
        }),
        onClick((Event event) {
          onMove(null);
        })
      ]),
      div([
        clazz('anchor', 'anchor-nw'),
        left(box.left - 8),
        top(box.top - 8),
        div(clazz('anchor-inner')),
        onMouseDown((Event event) {})
      ]),
      div([
        clazz('anchor', 'anchor-ne'),
        left(box.right - 8),
        top(box.top - 8),
        div(clazz('anchor-inner')),
        onMouseDown((Event event) {})
      ]),
      div([
        clazz('anchor', 'anchor-sw'),
        left(box.left - 8),
        top(box.bottom - 8),
        div(clazz('anchor-inner')),
        onMouseDown((Event event) {})
      ]),
      div([
        clazz('anchor', 'anchor-se'),
        left(box.right - 8),
        top(box.bottom - 8),
        div(clazz('anchor-inner')),
        onMouseDown((Event event) {})
      ])
    ];
  }
}

class ItemAdder implements Component {
  final ValueCallBack<PageItem> onAdd;

  ItemAdder({this.onAdd});

  @override
  build(BuildContext context) {
    return div([
      clazz('item-adder'),
      div([
        clazz('action'),
        icon('/img/item/text.png', size: 16),
        onClick((_) => onAdd(new TextItem()))
      ]),
      div([
        clazz('action'),
        icon('/img/item/image.png', size: 16),
        onClick((_) => onAdd(new ImageItem()))
      ]),
      div([
        clazz('action'),
        icon('/img/item/video.png', size: 16),
        onClick((_) => onAdd(new VideoItem()))
      ]),
    ]);
  }
}

Element icon(String src, {int size: 12, dynamic rootClass}) => span([
      bgImage('url(${src})'),
      style('background-size', 'contain'),
      style('background-repeat', 'no-repeat'),
      style('background-position', 'center'),
      width(size),
      height(size),
      style('display', 'inline-block'),
      style('flex-shrink', '0'),
      clazz(rootClass),
    ]);
