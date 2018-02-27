import 'dart:math';
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

  ImageFit fit;

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
      this.items,
      this.fit: ImageFit.cover}) {
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
  String get id;

  String name;

  int width;

  int height;

  int left;

  int top;

  PageItem clone();

  Rectangle<int> get rect;
}

abstract class PageItemMixin implements PageItem {
  Rectangle<int> get rect => new Rectangle(left, top, width, height);
}

enum Align { left, center, right }

class FontProperties {
  /// Size of the font
  int size;

  Align align;

  String family;

  String color;

  bool bold;

  bool italic;

  bool underline;

  bool lineThrough;

  FontProperties(
      {this.size: 16,
      this.align: Align.left,
      this.family,
      this.color: 'black',
      this.bold: false,
      this.italic: false,
      this.underline: false,
      this.lineThrough: false});

  FontProperties clone() {
    // TODO
  }
}

class TextItem extends Object with PageItemMixin implements PageItem {
  String id;

  String name;

  int width;

  int height;

  int left;

  int top;

  String text;

  FontProperties font;

  TextItem(
      {this.id,
      this.name: 'Text',
      this.width: 0,
      this.height: 0,
      this.left: 0,
      this.top: 0,
      this.text: 'Text',
      this.font}) {
    id ??= new ObjectId().toHexString();
    font ??= new FontProperties();
  }

  TextItem clone() {
    return new TextItem(
        name: name,
        width: width,
        height: height,
        left: left,
        top: top,
        text: text,
        font: font.clone());
  }
}

class ImageFit {
  final String bgSize;

  final String repeat;

  const ImageFit._(this.bgSize, this.repeat);

  static const none = const ImageFit._('auto', 'no-repeat');
  static const contain = const ImageFit._('contain', 'no-repeat');
  static const cover = const ImageFit._('cover', 'no-repeat');
  static const tile = const ImageFit._('auto', 'repeat');
}

class ImageItem extends Object with PageItemMixin implements PageItem {
  String id;

  String name;

  int width;

  int height;

  int left;

  int top;

  String url;

  ImageFit fit;

  ImageItem(
      {this.id,
      this.name: 'Image',
      this.width: 0,
      this.height: 0,
      this.left: 0,
      this.top: 0,
      this.url,
      this.fit: ImageFit.cover}) {
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

class VideoItem extends Object with PageItemMixin implements PageItem {
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
