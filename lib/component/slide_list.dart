import 'dart:html' as html;
import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';

import 'package:client/models/models.dart';

import 'package:client/service/data.dart';

class SlideListControls implements Component {
  final int numSelected;

  SlideListControls(this.numSelected);

  @override
  dynamic build(BuildContext context) => div([
        clazz('slideslist-controls'),
        divWhen(numSelected == 0, [
          '+',
          clazz('slideslist-controls-item'),
          onClick((_) => state.program.newPage())
        ]),
        divWhen(numSelected >= 1, [
          '-',
          clazz('slideslist-controls-item'),
          onClick((_) => state.removeSelectedPages())
        ]),
        divWhen(numSelected == 1, [
          '*',
          clazz('slideslist-controls-item'),
          onClick((_) => state.program.duplicatePage(state.editingId))
        ]),
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
      return div([clazz('slidelist-dropzone'), 'Move it here?']);
    return div([
      slideSelectorComp(isSelected,
          onChange: (_) => state.toggleSelection(page), key: page.id),
      div([clazz('slideslist-item-thumb-holder')]),
      span([
        page.name,
        clazz('slideslist-item-title'),
        when(isDraggable, onMouseDown((Event e) {
          html.MouseEvent event = e.event;
          state.dragged = page.id;
          state.oldPos = state.program.pages.indexOf(page);
          state.dragXPos = event.offset.x;
          state.dragYPos = event.offset.y;
        })),
      ]),
      clazz('slideslist-item-holder'),
      clazzIf(isEditing, 'editing'),
      when(state.dragged != null, style('pointer-events', 'none')),
      onClick((_) => state.editingId = page.id),
      new Symbol(page.id),
    ]);
  }

  List<Setter> get rootProps => <Setter>[];
}

class SlideListComponent implements Component {
  final List<Page> pages;

  final String editing;

  final Set<String> selected;

  SlideListComponent(this.pages, this.editing, this.selected);

  @override
  dynamic build(BuildContext context) => div([
        clazz('slideslist-main'),
        new Symbol('slides-list'),
        div(
          [
            #slidesHolder,
            flat(
              foreach(
                  pages,
                  (p) => new SlideThumbnail(p, p.id == editing,
                      selected.contains(p.id), selected.length == 0)),
              div([
                '+',
                clazz('slideslist-add'),
                state.dragged != null ? style('pointer-events', 'none') : null,
                onClick((_) {
                  state.program.newPage();
                })
              ]),
              when(
                  state.dragged != null,
                  () => div([
                        state.draggedPage.name,
                        clazz('slideslist-dragged'),
                        style('left', '${state.dragXPos - 10}px'),
                        style('top', '${state.dragYPos - 10}px'),
                      ])),
            ),
            clazz('slideslist-list'),
            onWheel(_scroll),
            state.dragged != null ? style('cursor', 'col-resize') : null,
            state.dragged != null
                ? onMouseMove((Event e) {
                    html.Element el = e.getNodeBySymbol(#slidesHolder);
                    if (state.dragged != null && el != null) {
                      html.MouseEvent event = e.event;
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

  void _scroll(Event e) {
    html.WheelEvent w = e.event;
    html.Element el = e.getNodeBySymbol(#slidesHolder);
    if (w.deltaY < 0) {
      el?.scrollLeft -= 100;
    } else if (w.deltaY > 0) {
      el?.scrollLeft += 100;
    }
  }
}

Element slideSelectorComp(bool isSelected,
    {List<Setter> set = const [], void onChange(bool state), key}) {
  return div([
    when(isSelected, '\u2713'),
    clazz('slide-selector'),
    clazzIf(isSelected, 'selected'),
    onClick((_) {
      if (onChange != null) onChange(isSelected);
    }),
    new Symbol(key)
  ]..addAll(set));
}
