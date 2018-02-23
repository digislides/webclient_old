import 'dart:html' as html;
import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';
import 'package:domino/setters.dart';

import 'package:client/models/models.dart';

import 'package:client/service/data.dart';

class SlideListControls implements Component {
  final int numSelected;

  SlideListControls(this.numSelected);

  @override
  dynamic build(BuildContext context) => div(content: [
        when(
            numSelected == 0,
            div(content: '+', set: [
              clazz('slideslist-controls-item'),
              onClick((_) => state.program.newPage())
            ])),
        when(
            numSelected >= 1,
            div(content: '-', set: [
              clazz('slideslist-controls-item'),
              onClick((_) => state.removeSelectedPages())
            ])),
        when(
            numSelected == 1,
            div(content: '*', set: [
              clazz('slideslist-controls-item'),
              onClick((_) => state.program.duplicatePage(state.editingId))
            ])),
      ], set: [
        clazz('slideslist-controls')
      ]);
}

class SlideThumbnail implements Component {
  final Page page;

  final bool isEditing;

  final bool isSelected;

  final bool isDraggable;

  SlideThumbnail(this.page, this.isEditing, this.isSelected, this.isDraggable);

  @override
  dynamic build(BuildContext context) {
    if (page.id == state.dragged)
      return div(set: [clazz('slidelist-dropzone')], content: 'Move it here?');
    return div(content: [
      slideSelectorComp(isSelected,
          onChange: (_) => state.toggleSelection(page), key: page.id),
      div(classes: ['slideslist-item-thumb-holder']),
      span(
        content: page.name,
        classes: ['slideslist-item-title'],
        set: when(isDraggable, onMouseDown((Event e) {
          html.MouseEvent event = e.domEvent;
          state.dragged = page.id;
          state.oldPos = state.program.pages.indexOf(page);
          state.dragXPos = event.offset.x;
          state.dragYPos = event.offset.y;
        })),
      )
    ], set: rootProps, key: page.id);
  }

  List<Setter> get rootProps => <Setter>[
        clazz('slideslist-item-holder'),
        clazzIf(isEditing, 'editing'),
        when(state.dragged != null, style('pointer-events', 'none')),
        onClick((_) => state.editingId = page.id),
      ];
}

class SlideListComponent implements Component {
  final List<Page> pages;

  final String editing;

  final Set<String> selected;

  SlideListComponent(this.pages, this.editing, this.selected);

  @override
  dynamic build(BuildContext context) =>
      div(set: clazz('slideslist-main'), key: 'slides-list', content: [
        div(
          key: 'slides-holder',
          content: flat(
            foreach(
                pages,
                (p) => new SlideThumbnail(p, p.id == editing,
                    selected.contains(p.id), selected.length == 0)),
            div(content: '+', set: [
              clazz('slideslist-add'),
              state.dragged != null ? style('pointer-events', 'none') : null,
              onClick((_) {
                state.program.newPage();
              })
            ]),
            when(
                state.dragged != null,
                () => div(content: state.draggedPage.name, set: [
                      clazz('slideslist-dragged'),
                      style('left', '${state.dragXPos - 10}px'),
                      style('top', '${state.dragYPos - 10}px'),
                    ])),
          ),
          afterInsert: _update,
          afterUpdate: _update,
          set: [
            clazz('slideslist-list'),
            onWheel(_scroll),
            state.dragged != null ? style('cursor', 'col-resize') : null,
            state.dragged != null
                ? onMouseMove((Event e) {
                    html.Element el = storage.getByKey('slideslist.element');
                    if (state.dragged != null && el != null) {
                      html.MouseEvent event = e.domEvent;
                      state.dragXPos = el.scrollLeft + event.offset.x;
                      state.dragYPos = event.offset.y;
                      final int newPos = state.dragXPos ~/ 110;
                      state.program.movePageTo(state.dragged, newPos);
                      if (state.dragXPos > (el.offsetWidth - 55)) {
                        el.scrollLeft += 10;
                        state.dragXPos += 10;
                      } else if (state.dragXPos < (el.scrollLeft + 55)) {
                        el.scrollLeft -= 10;
                        state.dragXPos -= 10;
                      }
                    }
                  })
                : null,
            state.dragged != null
                ? onMouseUp((Event e) {
                    state.dragged = null;
                    state.oldPos = null;
                    state.dragXPos = null;
                    state.dragYPos = null;
                  })
                : null,
            state.dragged != null
                ? onMouseOut((Event e) {
                    state.dragged = null;
                    state.oldPos = null;
                    state.dragXPos = null;
                    state.dragYPos = null;
                  })
                : null,
          ],
        ),
        new SlideListControls(selected.length),
      ]);

  void _update(dynamic node) {
    storage.replace('slideslist.element', node);
  }

  void _scroll(Event e) {
    html.WheelEvent w = e.domEvent;
    html.Element el = storage.getByKey('slideslist.element');
    if (w.deltaY < 0) {
      el?.scrollLeft -= 100;
    } else if (w.deltaY > 0) {
      el?.scrollLeft += 100;
    }
  }
}

List foreach<E>(List<E> list, build(E e)) => list.map(build).toList();

class AfterInsert implements Setter {
  final AfterCallback handler;

  const AfterInsert(this.handler);

  @override
  void apply(Element element) {
    element.afterInsert(handler);
  }
}

class SlideSelectComp implements Component {
  final bool isSelected;

  SlideSelectComp(this.isSelected);

  @override
  dynamic build(BuildContext context) {
    return div();
  }
}

Element slideSelectorComp(bool isSelected,
    {List<Setter> set = const [], void onChange(bool state), key}) {
  return div(
      content: isSelected ? '\u2713' : '',
      set: [
        clazz('slide-selector'),
        clazzIf(isSelected, 'selected'),
        onClick((_) {
          if (onChange != null) onChange(isSelected);
        })
      ]..addAll(set),
      key: key);
}
