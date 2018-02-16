import 'package:domino/node_helpers.dart';
import 'package:domino/domino.dart';
import 'package:domino/setters.dart';

import 'package:client/models/models.dart';

class SlideListControls implements Component {
  final int selected;

  SlideListControls(this.selected);

  @override
  dynamic build(BuildContext context) {}
}

class SlideThumbnail implements Component {
  final Page page;

  SlideThumbnail(this.page);

  @override
  dynamic build(BuildContext context) => div(content: [div(), span()]);
}

class SlideListComponent implements Component {
  List<Page> pages = [];

  SlideListComponent(this.pages);

  @override
  dynamic build(BuildContext context) => div(content: [
        div(content: pages.forEach((p) => new SlideThumbnail(p))),
        new SlideListControls(0),
      ], set: [
        clazz('holder')
      ]);
}
