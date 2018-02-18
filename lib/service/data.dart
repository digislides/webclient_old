import 'dart:async';

import 'package:client/models/models.dart';

abstract class DataService {
  FutureOr<Program> getProgramById(String id);
}

class StateService {
  Set<String> selectedIds = new Set<String>();

  String editingPage;

  Program program;

  void toggleSelection(Page page) {
    String id = page.id;
    if(selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }
}

class MockService implements DataService {
  Program getProgramById(String id) {
    return new Program()
      ..pages = <Page>[
        new Page()
          ..id = '1'
          ..name = "Page 1"
          ..width = 100
          ..height = 100,
        new Page()
          ..id = '2'
          ..name = "Page 2"
          ..width = 100
          ..height = 100,
        new Page()
          ..id = '3'
          ..name = "Page 3"
          ..width = 100
          ..height = 100,
        new Page()
          ..id = '4'
          ..name = "Page 4"
          ..width = 100
          ..height = 100
      ];
  }
}

DataService service = new MockService();

StateService state = new StateService();