import 'dart:async';

import 'package:flutter/widgets.dart';
import '../reactive_mvvm.dart';

class FormModelBuilder<TModel extends FormModel>
    extends ModelBuilder<TModel, BaseEvent> {
  FormModelBuilder(
      {required TModel form,
      required Widget Function(BuildContext context, TModel form,
              BaseEvent? previousEvent, BaseEvent? event)
          builder,
      void Function(BaseEvent? previous, BaseEvent? current)? listener,
      bool Function(TModel model, BaseEvent? previous, BaseEvent? current)?
          buildWhen})
      : super(
            builder: builder,
            model: form,
            buildWhen: buildWhen,
            listener: listener);

  @override
  State<StatefulWidget> createState() => FormModelBuilderState<TModel>();
}

class FormModelBuilderState<TModel extends FormModel>
    extends State<FormModelBuilder<TModel>> {
  late BaseEvent oldEvent;
  late BaseEvent event;
  late StreamSubscription<BaseEvent> subscription;

  @override
  void initState() {
    super.initState();

    setState(() {
      event = FormChangedEvent(form: widget.model, status: widget.model.status);
      oldEvent = event;
    });

    subscription = widget.model.changes.listen((newEvent) {
      final oldEvent = event;
      if ((widget.buildWhen == null && event is FieldChangedEvent) ||
          (widget.buildWhen != null &&
              !widget.buildWhen!(widget.model, oldEvent, newEvent))) return;

      setState(() {
        event = event;
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
