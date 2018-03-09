import 'dart:html';
import 'package:domino/html_view.dart';
import 'package:client/component/dashboard/dashboard.dart';
import 'package:client/service/dashboard/service.dart';
import 'package:client/service/dashboard/server.dart';

main() async {
  state.service = service;
  state.context = await service.getPrograms();
  registerHtmlView(querySelector('body'), new Dashboard());
}
