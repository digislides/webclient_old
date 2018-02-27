import 'dart:async';

import 'package:client/models/models.dart';

abstract class DataService {
  FutureOr<Program> getProgramById(String id);
}

class StateService {
  Set<String> selectedIds = new Set<String>();

  String editingId;

  Program program;

  String dragged;

  int dragXPos;

  int dragYPos;

  int oldPos;

  Page get editingPage {
    if (editingId == null) return null;
    return program.pages
        .firstWhere((p) => p.id == editingId, orElse: () => null);
  }

  Page get draggedPage {
    if (dragged == null) return null;
    return program.pages.firstWhere((p) => p.id == dragged, orElse: () => null);
  }

  void toggleSelection(Page page) {
    String id = page.id;
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  void removeSelectedPages() {
    program.removePagesById(selectedIds);
    if (selectedIds.contains(editingId)) {
      if (program.pages.length > 0)
        editingId = program.pages.first.id;
      else
        editingId = null;
    }
    selectedIds.clear();
  }
}

class MockService implements DataService {
  Program getProgramById(String id) {
    return new Program(name: 'Medis', width: 300, height: 150)
      ..newPage(
        name: "Page 1",
        color: 'blue',
        items: [
          new TextItem(
              width: 50, height: 50, left: 50, top: 50, text: 'Hello people!'),
        ],
      )
      ..newPage(
          name: "Page 2",
          color: 'green',
          image:
              'https://hips.hearstapps.com/pop.h-cdn.co/assets/cm/15/05/54cb00c759e04_-_mars-2020-1212-k24s8k-mdn.jpg?crop=1xw:0.6666666666666666xh;center,top&resize=640:*')
      ..newPage(name: "Page 3", color: 'yellow')
      ..newPage(name: "Page 4", color: 'orange');
  }
}

class StateStorage {
  Map<dynamic, dynamic> _storage = <dynamic, dynamic>{};

  dynamic insertIfNotExists(dynamic key, dynamic state) =>
      _storage.putIfAbsent(key, () => state);

  void replace(dynamic key, dynamic state) => _storage[key] = state;

  dynamic getByKey(dynamic key) => _storage[key];

  dynamic remove(dynamic key) => _storage.remove(key);
}

final StateStorage storage = new StateStorage();

DataService service = new MockService();

StateService state = new StateService();
