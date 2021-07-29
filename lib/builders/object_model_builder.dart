part of mvvm;

class ObjectModelBuilder<TObject>
    extends ModelBuilder<ObjectModel<TObject>, ObjectChangedEvent<TObject>> {
  const ObjectModelBuilder({
    required ObjectModel<TObject> objectModel,
    required Widget Function(
            BuildContext context,
            ObjectModel<TObject> objectModel,
            ObjectChangedEvent<TObject>? previousEvent,
            ObjectChangedEvent<TObject>? event)
        builder,
    void Function(ObjectChangedEvent<TObject>? previous,
            ObjectChangedEvent<TObject>? current)?
        listener,
    bool Function(
            ObjectModel<TObject> objectModel,
            ObjectChangedEvent<TObject>? previous,
            ObjectChangedEvent<TObject>? current)?
        buildWhen,
  }) : super(
            builder: builder,
            model: objectModel,
            buildWhen: buildWhen,
            listener: listener);

  @override
  State<StatefulWidget> createState() => ObjectModelBuilderState<TObject>();
}

class ObjectModelBuilderState<TObject>
    extends State<ObjectModelBuilder<TObject>> {
  late ObjectChangedEvent<TObject>? oldEvent;
  late ObjectChangedEvent<TObject>? event;
  late StreamSubscription<ObjectChangedEvent<TObject>> subscription;

  @override
  void initState() {
    setState(() {
      oldEvent = null;
      event = null;
    });

    subscription = widget.model.changes.listen((newEvent) {
      if (newEvent == oldEvent) return;

      setState(() {
        oldEvent = event;
        event = newEvent;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, widget.model, oldEvent, event);
}
