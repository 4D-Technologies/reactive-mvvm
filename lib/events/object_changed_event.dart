part of mvvm;

class ObjectChangedEvent<TObject> extends BaseEvent {
  final TObject? object;
  final ObjectModel<TObject> model;
  ObjectChangedEvent(ObjectModel<TObject> model)
      : object = model.value,
        this.model = model;
}
