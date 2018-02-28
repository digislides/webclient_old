import 'dart:html' as html;
import 'properties_editor/item/state.dart';
import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';
import 'package:client/models/models.dart';
import 'package:domino_nodes/domino_nodes.dart' as dn;
import 'dart:math';

class _State {
  bool moving = false;
  Point<num> mouse;
  bool resize;
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
      #stageViewport,
      onClick((event) {
        onSelect(null);
        event.stopImmediatePropagation();
      }),
      div([
        clazz('stage-canvas'),
        style('width', '${width + 300}px'),
        style('height', '${height + 300}px'),
        attr('tabIndex', '0'),
        clazzIf(state.moving, 'moving'),
        clazzIf(state.resize == false, 'resizing-h'),
        clazzIf(state.resize == true, 'resizing-v'),
        when(
            selectedItem != null && state.moving && state.mouse != null,
            () => [
                  new MoveShow(new Rectangle(state.mouse.x, state.mouse.y,
                      selectedItem.width, selectedItem.height)),
                  onMouseUp((Event event) {
                    selectedItem.left = state.mouse.x - 150;
                    selectedItem.top = state.mouse.y - 150;
                    state.mouse = null;
                    state.resize = null;
                  }),
                ]),
        when(
            selectedItem != null && state.resize != null && state.mouse != null,
            () => [
                  when(
                      state.resize,
                      new MoveShow(new Rectangle(
                          150 + selectedItem.left,
                          150 + selectedItem.top,
                          selectedItem.width,
                          _positive(state.mouse.y - (150 + selectedItem.top)))),
                      new MoveShow(new Rectangle(
                          150 + selectedItem.left,
                          150 + selectedItem.top,
                          _positive(state.mouse.x - (150 + selectedItem.left)),
                          selectedItem.height))),
                  onMouseUp((Event event) {
                    if (state.resize) {
                      selectedItem.height =
                          _positive(state.mouse.y - (150 + selectedItem.top));
                    } else {
                      selectedItem.width =
                          _positive(state.mouse.x - (150 + selectedItem.left));
                    }
                    state.moving = false;
                    state.mouse = null;
                    state.resize = null;
                  }),
                ]),
        onMouseOut((Event event) {
          state.moving = false;
          state.mouse = null;
          state.resize = null;
        }),
        onMouseUp((Event event) {
          state.moving = false;
          state.mouse = null;
          state.resize = null;
        }),
        onKeyDown((Event event) {
          html.KeyboardEvent e = event.event;
          if (e.keyCode == html.KeyCode.ESC) {
            state.moving = false;
            state.mouse = null;
            state.resize = null;
          }
        }),
        when(selectedItem != null && (state.moving || state.resize != null),
            onMouseMove((Event event) {
          html.MouseEvent e = event.event;
          if (state.moving || state.resize != null) {
            state.mouse = e.offset;
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
          when(selectedItem != null && (state.moving || state.resize != null),
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
              () => new Anchors(selectedItem.rect, onMove: (_) {
                    state.moving = true;
                  }, onResize: (bool dir) {
                    state.resize = dir;
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

  static int _positive(int v) => v >= 0 ? v : 0;
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

  final ValueCallBack<bool> onMove;

  final ValueCallBack<bool> onResize;

  Anchors(this.box, {this.onMove, this.onResize});

  @override
  build(BuildContext context) {
    return [
      div([
        clazz('anchors'),
        left(box.left),
        top(box.top),
        width(box.width),
        height(box.height),
        onClick((Event event) {
          // Deselect
        })
      ]),
      div([
        clazz('anchor-move'),
        left(box.left - 4),
        top(box.top - 4),
        onMouseDown((Event event) {
          onMove(true);
        })
      ]),
      div([
        clazz('anchor', 'anchor-e'),
        left(box.right - 3),
        top(box.top + (box.height ~/ 2) - 8),
        onMouseDown((Event event) {
          onResize(false);
        })
      ]),
      div([
        clazz('anchor', 'anchor-s'),
        left(box.left + (box.width ~/ 2) - 8),
        top(box.bottom - 3),
        onMouseDown((Event event) {
          onResize(true);
        })
      ]),
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
