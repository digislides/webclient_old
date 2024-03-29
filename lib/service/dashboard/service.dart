import 'dart:async';
import 'package:client/models/models.dart';

class ProgramCreator {
  String name;

  int width;

  int height;

  Map toJson() => {
    'name': name,
    'width': width,
    'height': height,
  };
}

abstract class Service {
  FutureOr<List<Program>> getPrograms();

  FutureOr<Program> getProgramById(String id);

  FutureOr<Program> createPrograms(ProgramCreator program);

  FutureOr<Program> editProgram(String id, ProgramCreator program);

  FutureOr<List<Program>> deleteProgram(String id);

  FutureOr<Program> duplicateProgram(String id);

  FutureOr<List<Player>> getPlayers();

  FutureOr<Player> getPlayerById(String id);

  FutureOr<Player> createPlayer(ProgramCreator player);

  // TODO edit player

  FutureOr<List<Player>> deletePlayer(String id);

  FutureOr<Player> duplicatePlayer(String id);
}

class State {
  dynamic context;

  Service service;
}

State state = new State();