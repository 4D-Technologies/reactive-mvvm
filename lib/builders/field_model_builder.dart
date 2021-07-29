part of mvvm;

enum FieldModelRebuild { change, post }

class FieldModelBuilder<TSource, TDestination>
    extends ModelBuilder<FieldModel<TSource, TDestination>, BaseEvent> {
  final FieldModelRebuild rebuildWhen;

  const FieldModelBuilder(
      {this.rebuildWhen = FieldModelRebuild.change,
      required FieldModel<TSource, TDestination> field,
      required Widget Function(
              BuildContext context,
              FieldModel<TSource, TDestination> field,
              BaseEvent? previousEvent,
              BaseEvent? event)
          builder,
      void Function(BaseEvent? previous, BaseEvent? current)? listener,
      bool Function(FieldModel<TSource, TDestination> field,
              BaseEvent? previous, BaseEvent? current)?
          buildWhen})
      : super(
            builder: builder,
            model: field,
            buildWhen: buildWhen,
            listener: listener);

  @override
  State<StatefulWidget> createState() =>
      FieldModelBuilderState<TSource, TDestination>();
}

class FieldModelBuilderState<TSource, TDestination>
    extends State<FieldModelBuilder<TSource, TDestination>> {
  late BaseFieldEvent<dynamic, dynamic> oldEvent;
  late BaseFieldEvent<dynamic, dynamic> event;
  late StreamSubscription<BaseEvent> subscription;

  @override
  void initState() {
    setState(() {
      event =
          FieldCreatedEvent<dynamic, dynamic>(widget.model, widget.model.value);
      oldEvent = event;
    });

    subscription = widget.model.changes.listen((newEvent) {
      oldEvent = event;

      if (widget.buildWhen == null) {
        switch (widget.rebuildWhen) {
          case FieldModelRebuild.change:
            if (!(newEvent is FieldChangedEvent)) {
              return;
            }
            break;
          case FieldModelRebuild.post:
            if (!(newEvent is FieldPostedEvent)) {
              return;
            }
            break;
        }
      } else if (newEvent is BaseFieldEvent) {
        if (!widget.buildWhen!(widget.model, oldEvent, newEvent)) return;
      } else {}

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
