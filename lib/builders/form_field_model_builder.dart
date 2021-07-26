import 'dart:async';

import 'package:flutter/widgets.dart';

import '../reactive_mvvm.dart';
import 'field_model_builder.dart';

class FormFieldModelBuilder<TModel extends FormModel>
    extends ModelBuilder<TModel, BaseEvent> {
  final FieldModelRebuild rebuildWhen;
  final Iterable<FieldModel<dynamic, dynamic>> Function(TModel form)? fields;
  const FormFieldModelBuilder(
      {this.rebuildWhen = FieldModelRebuild.change,
      this.fields,
      required TModel form,
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
  State<StatefulWidget> createState() => FormFieldModelBuilderState<TModel>();
}

class FormFieldModelBuilderState<TModel extends FormModel>
    extends State<FormFieldModelBuilder<TModel>> {
  late BaseEvent oldEvent;
  late BaseEvent event;
  late StreamSubscription<BaseEvent> subscription;

  @override
  void initState() {
    setState(() {
      event = FormChangedEvent(
          form: widget.model, status: widget.model.status, observables: []);
      oldEvent = event;
    });

    subscription = widget.model.changes.listen((newEvent) {
      oldEvent = event;

      if (widget.buildWhen == null) {
        switch (widget.rebuildWhen) {
          case FieldModelRebuild.change:
            if ((newEvent is FieldChangedEvent) &&
                (widget.fields == null ||
                    !widget.fields!(widget.model).contains(newEvent.model))) {
              return;
            }
            break;
          case FieldModelRebuild.post:
            if ((newEvent is FieldPostedEvent) &&
                (widget.fields == null ||
                    !widget.fields!(widget.model).contains(newEvent.model))) {
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
