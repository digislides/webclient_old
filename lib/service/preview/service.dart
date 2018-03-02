import 'dart:async';
import 'package:client/models/models.dart';
import 'package:domino/html_view.dart';

abstract class Service {
  FutureOr<Program> getProgramById(String id);
}

class State {
  Program program;

  int page = 0;

  Timer timer;

  View view;
}

State state = new State();