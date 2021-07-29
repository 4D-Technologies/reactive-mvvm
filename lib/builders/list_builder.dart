part of mvvm;

class ListBuilder<TModel> extends StatefulWidget {
  final ObservableList<TModel> list;
  final Widget Function(
      BuildContext context,
      ObservableList<TModel> list,
      ListChangedEvent<TModel> oldEvent,
      ListChangedEvent<TModel> newEvent) builder;
  final bool Function(
      ObservableList<TModel> list,
      ListChangedEvent<TModel> oldEvent,
      ListChangedEvent<TModel> newEvent)? buildWhen;

  const ListBuilder(
      {required this.list, required this.builder, this.buildWhen});

  @override
  State<StatefulWidget> createState() => ListBuilderState<TModel>();
}

class ListBuilderState<TModel> extends State<ListBuilder<TModel>> {
  late ListChangedEvent<TModel> event;
  late ListChangedEvent<TModel> oldEvent;
  late StreamSubscription<ListChangedEvent<TModel>> subscription;

  @override
  void initState() {
    super.initState();

    setState(() {
      event = ListChangedEvent(change: ListChangeTypes.create, elements: []);
      oldEvent = event;
    });

    subscription = widget.list.changes.listen((newEvent) {
      if ((widget.buildWhen == null &&
              newEvent.change == ListChangeTypes.update) ||
          (widget.buildWhen != null &&
              !widget.buildWhen!(widget.list, oldEvent, newEvent))) return;

      setState(() {
        oldEvent = event;
        event = newEvent;
      });
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, widget.list, oldEvent, event);
}
