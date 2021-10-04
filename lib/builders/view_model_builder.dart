part of mvvm;

class ViewModelBuilder<TViewModel extends ViewModel>
    extends ModelBuilder<TViewModel, BaseEvent> {
  final FutureOr<void> Function()? onLoad;
  const ViewModelBuilder({
    required TViewModel viewModel,
    this.onLoad,
    required Widget Function(BuildContext context, TViewModel viewModel,
            BaseEvent? previousEvent, BaseEvent? event)
        builder,
    void Function(BaseEvent? previous, BaseEvent? current)? listener,
    bool Function(
            TViewModel viewModel, BaseEvent? previous, BaseEvent? current)?
        buildWhen,
  }) : super(
            builder: builder,
            model: viewModel,
            buildWhen: buildWhen,
            listener: listener);

  @override
  State<StatefulWidget> createState() => ViewModelBuilderState<TViewModel>();
}

class ViewModelBuilderState<TViewModel extends ViewModel>
    extends State<ViewModelBuilder<TViewModel>> {
  BaseEvent? oldEvent;
  BaseEvent? event;
  late StreamSubscription<BaseEvent> subscription;
  bool loaded = false;

  @override
  void initState() {
    super.initState();

    if (widget.onLoad == null) {
      loaded = true;
      createSubscription();
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await widget.onLoad!();

        setState(
          () {
            loaded = true;
            createSubscription();
          },
        );
      });
    }
  }

  void createSubscription() {
    subscription = widget.model.changes.listen((newEvent) {
      if (newEvent == oldEvent) return;

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
      widget.builder(context, widget.model, oldEvent, event);
}
