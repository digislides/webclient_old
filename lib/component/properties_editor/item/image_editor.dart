import 'state.dart';
import 'package:domino/domino.dart';
import 'package:domino_nodes/domino_nodes.dart';

class ImageEditor implements Component {
  final String url;

  ImageEditor(this.url);

  @override
  build(BuildContext context) {
    return div([
      clazz('propitem-img'),
      div([
        clazz('propitem-img-display'),
        when(url != null && url.isNotEmpty, bgImage('url(${url})')),
        onClick((_) {
          // TODO
        }),
      ]),
    ]);
  }
}
