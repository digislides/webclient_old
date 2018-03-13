import 'dart:html';
import 'package:domino/html_view.dart';
import 'package:client/component/dashboard/dashboard.dart';
import 'package:client/service/dashboard/service.dart';
import 'package:client/service/dashboard/server.dart';
import 'package:jaguar_resty/jaguar_resty.dart';
import 'package:http/browser_client.dart' as http;

main() async {
  globalClient = new http.BrowserClient();
  state.service = service;
  state.context = await service.getPrograms();
  registerHtmlView(querySelector('body'), new Dashboard());
}
