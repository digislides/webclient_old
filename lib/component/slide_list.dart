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
              onClick((_) => state.program.duplicatePage(state.editingPage))
            ])),
      ], set: [
        clazz('slideslist-controls')
      ]);
}

class SlideThumbnail implements Component {
  final Page page;

  final bool isEditing;

  final bool isSelected;

  SlideThumbnail(this.page, this.isEditing, this.isSelected);

  @override
  dynamic build(BuildContext context) => div(content: [
        slideSelectorComp(isSelected,
            onChange: (_) => state.toggleSelection(page)),
        div(classes: ['slideslist-item-thumb-holder']),
        span(content: page.name, classes: ['slideslist-item-title'])
      ], set: rootProps);

  List<Setter> get rootProps => <Setter>[
        clazz('slideslist-item-holder'),
        clazzIf(isEditing, 'editing'),
        onClick((_) => state.editingPage = page.id),
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
                  (p) => new SlideThumbnail(
                      p, p.id == editing, selected.contains(p.id))),
              div(content: '+', set: [
                clazz('slideslist-add'),
                onClick((_) => state.program.newPage())
              ])),
          set: [
            clazz('slideslist-list'),
            onWheel(_scroll),
            new AfterInsert(_update),
            new AfterUpdate(_update),
          ],
        ),
        new SlideListControls(selected.length),
      ]);

  void _update(dynamic node) {
    storage.upsertByKey('slideslist.element', node);
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

class StateStorage {
  Map<String, dynamic> _storage = <String, dynamic>{};

  void upsertByKey(String key, dynamic state) => _storage[key] = state;

  dynamic getByKey(String key) => _storage[key];
}

final StateStorage storage = new StateStorage();

class SlideSelectComp implements Component {
  final bool isSelected;

  SlideSelectComp(this.isSelected);

  @override
  dynamic build(BuildContext context) {
    return div();
  }
}

Element slideSelectorComp(bool isSelected,
    {List<Setter> set = const [], void onChange(bool state)}) {
  return div(
      content: isSelected ? '\u2713' : '',
      set: [
        clazz('slide-selector'),
        clazzIf(isSelected, 'selected'),
        onClick((_) {
          if (onChange != null) onChange(isSelected);
        })
      ]..addAll(set));
}

dynamic when(condition, result) {
  if (condition is Function) condition = condition();
  if (condition) {
    if (result is Function) return result();
    return result;
  }
  return null;
}
