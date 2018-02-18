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

  String imageId;

  int duration = 5;

  int transition = 0;

  num transitionDuration = 0;

  List<PageItem> items = new List<PageItem>();

  Page();
}

class Program {
  List<Page> pages;



  void newPage() => pages.add(new Page()
    ..id = '1'
    ..name = 'New page');
}
