import 'dart:async';

import 'package:flutter/material.dart';
import '../reactive_mvvm.dart';

class PageModelBuilder<TModel extends ViewModel>
    extends ModelBuilder<TModel, BaseEvent> {
  final Widget loadingWidget;
  final Widget Function(BuildContext context, String? errorMessage)
      errorBuilder;

  PageModelBuilder(
      {required TModel view,
      required this.loadingWidget,
      required this.errorBuilder,
      required Widget Function(BuildContext context, TModel model,
              BaseEvent? previousEvent, BaseEvent? event)
          builder,
      void Function(BaseEvent? previous, BaseEvent? current)? listener,
      bool Function(TModel model, BaseEvent? previous, BaseEvent? current)?
          buildWhen})
      : super(
            builder: builder,
            listener: listener,
            model: view,
            buildWhen: buildWhen);

  @override
  State<StatefulWidget> createState() => PageModelBuilderState<TModel>();
}

class PageModelBuilderState<TModel extends ViewModel>
    extends State<PageModelBuilder<TModel>> {
  late BaseEvent event;
  late BaseEvent oldEvent;
  StreamSubscription<BaseEvent>? subscription;

  @override
  void initState() {
    super.initState();

    setState(() {
      event = widget.model.lastEvent;
      oldEvent = event;
    });

    createSubscription();
  }

  @override
  void didUpdateWidget(covariant PageModelBuilder<TModel> oldWidget) {
    super.didUpdateWidget(oldWidget);

    createSubscription();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  void createSubscription() {
    var isNew = true;
    if (subscription != null) {
      subscription!.cancel();
      subscription = null;
    }

    subscription = widget.model.changes.listen((newEvent) {
      if (newEvent == event && !isNew) return;
      isNew = false;
      oldEvent = event;

      final shouldBuild =
          !((widget.buildWhen == null && newEvent is FormChangedEvent) ||
              (widget.buildWhen == null && newEvent is FieldChangedEvent) ||
              (widget.buildWhen != null &&
                  !widget.buildWhen!(widget.model, oldEvent, newEvent)));

      if (shouldBuild) {
        if (oldEvent is ViewChangedEvent && newEvent is ViewChangedEvent) {
          if ((oldEvent as ViewChangedEvent).status == ViewStatus.loading &&
              newEvent.status != ViewStatus.loading &&
              newEvent.status != ViewStatus.error) {
            subscription!.cancel();
            createSubscription();
          }
        }

        setState(() {
          oldEvent = event;
          event = newEvent;
        });
      }

      if (widget.listener != null) widget.listener!(oldEvent, newEvent);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.status == ViewStatus.error) {
      return widget.errorBuilder(context, widget.model.errorMessage);
    } else if (widget.model.status == ViewStatus.loading) {
      return widget.loadingWidget;
    }

    return widget.builder(context, widget.model, oldEvent, event);
  }
}
