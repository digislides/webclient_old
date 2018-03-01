import 'dart:html' as html;
import 'state.dart';
import 'package:domino/domino.dart';
import 'package:domino_nodes/domino_nodes.dart';

class ImageEditor implements StatefulComponent {
  final String url;

  final StringCallBack onInput;

  EditableElementState myState;

  ImageEditor(this.url, {this.onInput});

  @override
  build(BuildContext context) {
    return div([
      clazz('propitem-img'),
      div([
        clazz('propitem-img-display'),
        div([
          clazz('propitem-img-display'),
          when(url != null && url.isNotEmpty, bgImage('url(${url})')),
          onClick((_) {
            myState.isEditing = !myState.isEditing;
          }),
          div([clazz('img')])
        ])
      ]),
      when(
          myState.isEditing,
          () => div([
                clazz('prop-dd', 'img-dd'),
                textInput([
                  #url,
                  afterInsert((Change change) {
                    change.node.value = url;
                    change.node.focus();
                  }),
                  onKeyDown((Event event) {
                    myState.original = event.element.value;
                    html.KeyboardEvent e = event.event;
                    if (e.keyCode == html.KeyCode.ENTER) {
                      onInput(event.element.value);
                      myState.isEditing = false;
                    }
                  })
                ]),
                div([
                  clazz('img-dd-disp'),
                  when(myState.original != null && myState.original.isNotEmpty,
                      bgImage('url(${myState.original})')),
                ]),
              ]))
    ]);
  }

  @override
  Component restoreState(Component previous) {
    if (previous is ImageEditor) {
      myState = previous.myState;
    } else {
      myState = new EditableElementState(url);
    }
  }
}
