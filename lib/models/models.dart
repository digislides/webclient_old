import 'package:bson_objectid/bson_objectid.dart';

abstract class PageItem {
  String get name;

  int get width;

  int get height;

  int get left;

  int get top;
}

class Page {
  String id = '';

  String name = "";

  int width = 0;

  int height = 0;

  String screenshot = "";

  String color = 'white';

  String image;

  int duration = 5;

  int transition = 0;

  num transitionDuration = 0;

  List<PageItem> items = new List<PageItem>();

  Page();

  Page clone() {
    // TODO items
    return new Page()
      ..name = name
      ..width = width
      ..height = height
      ..color = color
      ..image = image
      ..duration = duration
      ..transition = transition
      ..transitionDuration = transitionDuration;
  }
}

class Program {
  String name;

  int width = 0;

  int height = 0;

  final List<Page> pages = <Page>[];

  void removePagesById(Set<String> ids) {
    pages.removeWhere((p) => ids.contains(p.id));
  }

  void duplicatePage(String pageId) {
    final page = pages.firstWhere((p) => p.id == pageId, orElse: () => null);
    if (page == null) return;
    // TODO clone page
    Page dupPage = page.clone();
    // Give new page new id
    dupPage.id = new ObjectId().toHexString();
    // Add new page to pages
    int pos = pages.indexOf(page);
    pages.insert(pos + 1, dupPage);
  }

  void movePageTo(String pageId, int newPos) {
    final page = pages.firstWhere((p) => p.id == pageId, orElse: () => null);
    pages.remove(page);
    if (newPos < pages.length) {
      pages.insert(newPos, page);
    } else {
      pages.add(page);
    }
  }

  void newPage(
          {String id,
          String name: 'New page',
          String color: 'white',
          String image}) =>
      pages.add(new Page()
        ..id = id ?? new ObjectId().toHexString()
        ..name = name
        ..width = width
        ..height = height
        ..color = color
        ..image = image);
}

class Player {
  String id;

  String name;
}
