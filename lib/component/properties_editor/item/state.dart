import 'package:domino/domino.dart';

typedef void ValueCallBack<ValueType>(ValueType value);

typedef void StringCallBack(String value);

typedef void IntCallBack(int value);

abstract class State {}

class EditableElementState implements State {
  dynamic original;

  Element el;

  bool isEditing = false;

  EditableElementState(this.original);
}

abstract class Input<ValueType> {
  ValueCallBack<ValueType> get onInput;
}