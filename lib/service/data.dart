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
    selectedIds.clear();
  }
}

class MockService implements DataService {
  Program getProgramById(String id) {
    return new Program()
      ..name = 'Medis'
      ..width = 3000
      ..height = 1500
      ..newPage(name: "Page 1", color: 'blue')
      ..newPage(name: "Page 2", color: 'green')
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
