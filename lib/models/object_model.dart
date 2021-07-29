part of mvvm;

class ObjectModel<TObject> extends WidgetModel<ObjectChangedEvent<TObject>> {
  TObject? _object;

  ObjectModel(this._object);

  void set value(TObject? obj) {
    if (obj == _object) return;

    _object = obj;

    raiseEvent(
      ObjectChangedEvent(this),
    );
  }

  TObject? get value => _object;
}
