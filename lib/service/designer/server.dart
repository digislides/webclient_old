import 'dart:async';
import 'package:client/models/models.dart';
import 'data.dart';
import 'package:http/http.dart';
import 'package:http/browser_client.dart';
import 'dart:convert';

class MockService implements DataService {
  final BrowserClient client = new BrowserClient();

  Future<Program> getProgramById(String id) async {
    Response resp = await client.get('/api/program/$id');

    if (resp.statusCode == 200) {
      return new Program()..fromMap(JSON.decode(resp.body));
    }

    throw new Exception(); // TODO
  }

  @override
  Future<Program> saveProgram(String id, Program program) async {
    Response resp =
        await client.put('/api/program/$id', body: JSON.encode(program.toMap));

    if (resp.statusCode == 200) {
      return new Program()..fromMap(JSON.decode(resp.body));
    }

    throw new Exception(); // TODO
  }

  Future<Program> publish(String id) async {
    Response resp = await client.post('/api/program/publish/$id');

    if (resp.statusCode == 200) {
      return new Program()..fromMap(JSON.decode(resp.body));
    }

    throw new Exception(); // TODO
  }
}

DataService service = new MockService();
