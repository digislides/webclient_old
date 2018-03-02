import 'dart:async';

import 'package:client/models/models.dart';

abstract class DataService {
  FutureOr<Program> getProgramById(String id);

  FutureOr saveProgram(String id, Program program);
}

class StateService {
  Set<String> selectedIds = new Set<String>();

  String _editingId;

  Program _program;

  Program get program => _program;

  set program(Program v) {
    _program = v;
    _editingId = _program.pages.first.id;
  }

  String dragged;

  int dragXPos;

  int dragYPos;

  int oldPos;

  PageItem selectedItem;

  String get editingId => _editingId;

  set editingId(String v) {
    _editingId = v;
    selectedItem = null;
  }

  Page get editingPage {
    if (_editingId == null) return null;
    return program.pages
        .firstWhere((p) => p.id == _editingId, orElse: () => null);
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
    if (selectedIds.contains(_editingId)) {
      if (program.pages.length > 0)
        editingId = program.pages.first.id;
      else
        editingId = null;
    }
    selectedIds.clear();
  }

  void deleteItem(PageItem item) {
    editingPage.items.removeWhere((i) => i.id == item.id);
    if (selectedItem?.id == item.id) {
      selectedItem = null;
    }
  }

  dynamic overlay;
}

StateService state = new StateService();
