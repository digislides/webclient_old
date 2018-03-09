import 'dart:async';
import 'service.dart';
import 'package:client/models/models.dart';
import 'package:jaguar_resty/jaguar_resty.dart';

class HttpService implements Service {
  Route program = route('/api/program');

  @override
  Future<List<Program>> getPrograms() => program.get.fetchList(Program.map);

  @override
  Future<Program> getProgramById(String id) =>
      program.get.path(id).fetch(Program.map);

  @override
  Future<Program> createPrograms(ProgramCreator creator) =>
      program.post.json(creator.toMap).fetch(Program.map);

  @override
  Future<Program> editProgram(String id, ProgramCreator editor) =>
      program.put.path('/edit/${id}').json(editor.toMap).fetch(Program.map);

  @override
  Future<List<Program>> deleteProgram(String id) =>
      program.delete.path(id).fetchList(Program.map);

  @override
  Future<Program> duplicateProgram(String id) =>
      program.post.path(id).fetch(Program.map);
}

HttpService service = new HttpService();
