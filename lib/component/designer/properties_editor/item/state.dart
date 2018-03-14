typedef void ValueCallBack<ValueType>(ValueType value);

typedef void BoolCallBack(bool value);

typedef void StringCallBack(String value);

typedef void IntCallBack(int value);

abstract class State {}

class EditableElementState<VT> implements State {
  VT original;

  bool isEditing = false;

  EditableElementState(this.original);
}

abstract class Input<ValueType> {
  ValueCallBack<ValueType> get onInput;
}
