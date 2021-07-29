part of mvvm;

class WidgetModelBuilder<TEvent extends BaseEvent,
    TModel extends IObservable<TEvent>> extends ModelBuilder<TModel, TEvent> {
  final TEvent? initialEvent;
  WidgetModelBuilder(
      {required TModel model,
      required this.initialEvent,
      required Widget Function(BuildContext context, TModel model,
              TEvent? previousEvent, TEvent? event)
          builder,
      bool Function(TModel model, TEvent? previous, TEvent? current)? buildWhen,
      void Function(TEvent? previous, TEvent? current)? listener})
      : super(
            model: model,
            buildWhen: buildWhen,
            builder: builder,
            listener: listener);
  @override
  State<StatefulWidget> createState() =>
      WidgetModelBuilderState<TEvent, TModel>();
}

class WidgetModelBuilderState<TEvent extends BaseEvent,
        TModel extends IObservable<TEvent>>
    extends State<WidgetModelBuilder<TEvent, TModel>> {
  late TEvent? event;
  late TEvent? oldEvent;

  late StreamSubscription<TEvent> subscription;

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      event = widget.initialEvent;
      oldEvent = widget.initialEvent;
    });

    subscription = widget.model.changes.listen((newEvent) {
      if (newEvent == event) return;
      if ((widget.buildWhen != null &&
          !widget.buildWhen!(widget.model, oldEvent, newEvent))) return;

      setState(() {
        oldEvent = event;
        event = newEvent;
      });
    });
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, widget.model, oldEvent, event);
}
