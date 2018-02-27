import 'package:bson_objectid/bson_objectid.dart';

class Player {
  String id;

  String name;
}

class Page {
  String id;

  String name;

  int width;

  int height;

  String color;

  String image;

  int duration;

  int transition;

  num transitionDuration;

  List<PageItem> items;

  Page(
      {this.id,
      this.name: 'Page',
      this.width: 0,
      this.height: 0,
      this.color: 'white',
      this.image,
      this.duration: 5,
      this.transition: 0,
      this.transitionDuration: 0,
      this.items}) {
    id ??= new ObjectId().toHexString();
    items ??= new List<PageItem>();
  }

  Page clone() {
    return new Page(
        name: name,
        width: width,
        height: height,
        color: color,
        image: image,
        duration: duration,
        transition: transition,
        transitionDuration: transitionDuration,
        items: items.map((i) => i.clone()).toList());
  }
}

class Program {
  String id;

  String name;

  int width = 0;

  int height = 0;

  List<Page> pages;

  Program(
      {this.id,
      this.name: 'Program',
      this.width: 0,
      this.height: 0,
      this.pages}) {
    id ??= new ObjectId().toHexString();
    pages ??= <Page>[];
  }

  void removePagesById(Set<String> ids) {
    pages.removeWhere((p) => ids.contains(p.id));
  }

  void duplicatePage(String pageId) {
    final page = pages.firstWhere((p) => p.id == pageId, orElse: () => null);
    if (page == null) return;
    Page dupPage = page.clone();
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
          int width,
          int height,
          String color: 'white',
          String image,
          List<PageItem> items}) =>
      pages.add(new Page(
          id: id,
          name: name,
          width: width ?? this.width,
          height: height ?? this.height,
          color: color,
          image: image,
          items: items));
}

abstract class PageItem {
  String get name;

  int get width;

  int get height;

  int get left;

  int get top;

  PageItem clone();
}

class TextItem implements PageItem {
  String id;

  String name;

  int width;

  int height;

  int left;

  int top;

  String text;

  TextItem(
      {this.id,
      this.name: 'Text',
      this.width: 0,
      this.height: 0,
      this.left: 0,
      this.top: 0,
      this.text: ''}) {
    id ??= new ObjectId().toHexString();
  }

  TextItem clone() {
    return new TextItem(
        name: name,
        width: width,
        height: height,
        left: left,
        top: top,
        text: text);
  }
}

class ImageItem implements PageItem {
  String id;

  String name;

  int width;

  int height;

  int left;

  int top;

  String url;

  ImageItem(
      {this.id,
      this.name: 'Image',
      this.width: 0,
      this.height: 0,
      this.left: 0,
      this.top: 0,
      this.url}) {
    id ??= new ObjectId().toHexString();
  }

  ImageItem clone() {
    return new ImageItem(
        name: name,
        width: width,
        height: height,
        left: left,
        top: top,
        url: url);
  }
}

class VideoItem implements PageItem {
  String id;

  String name;

  int width;

  int height;

  int left;

  int top;

  String url;

  VideoItem(
      {this.id,
      this.name: 'Video',
      this.width: 0,
      this.height: 0,
      this.left: 0,
      this.top: 0,
      this.url}) {
    id ??= new ObjectId().toHexString();
  }

  VideoItem clone() {
    return new VideoItem(
        name: name,
        width: width,
        height: height,
        left: left,
        top: top,
        url: url);
  }
}
