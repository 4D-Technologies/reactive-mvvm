import 'dart:async';

import 'package:flutter/widgets.dart';

import '../reactive_mvvm.dart';

class ViewModelBuilder<TViewModel extends ViewModel>
    extends ModelBuilder<TViewModel, BaseEvent> {
  const ViewModelBuilder({
    required TViewModel viewModel,
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
  late BaseEvent? oldEvent;
  late BaseEvent? event;
  late StreamSubscription<BaseEvent> subscription;

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
