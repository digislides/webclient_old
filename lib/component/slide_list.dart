import 'dart:html' as html;
import 'package:domino_nodes/domino_nodes.dart';
import 'package:domino/domino.dart';
import 'package:domino/setters.dart';

import 'package:client/models/models.dart';

import 'package:client/service/data.dart';

class SlideListControls implements Component {
  final int selected;

  SlideListControls(this.selected);

  @override
  dynamic build(BuildContext context) => div(content: []);
}

class SlideThumbnail implements Component {
  final Page page;

  final bool isEditing;

  SlideThumbnail(this.page, this.isEditing);

  @override
  dynamic build(BuildContext context) => div(content: [
        div(set: thumbHolderProps),
        span(content: page.name, set: titleProps)
      ], set: rootProps);

  List<Setter> get rootProps => <Setter>[
        clazz('slideslist-item-holder'),
        clazzIf(isEditing, 'editing'),
        onClick((_) => state.editingPage = page.id),
      ];

  static final thumbHolderProps = <Setter>[
    clazz('slideslist-item-thumb-holder'),
  ];

  static final titleProps = <Setter>[
    clazz('slideslist-item-title'),
  ];
}

class SlideListComponent implements Component {
  List<Page> pages = [];

  String editing;

  SlideListComponent(this.pages, this.editing);

  @override
  dynamic build(BuildContext context) =>
      div(set: clazz('slideslist-main'), key: 'slides-list', content: [
        div(
          key: 'slides-holder',
          content: flat(
              foreach(pages, (p) => new SlideThumbnail(p, p.id == editing)),
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
        new SlideListControls(0),
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
