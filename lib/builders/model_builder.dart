import 'package:flutter/widgets.dart';

import '../reactive_mvvm.dart';

abstract class ModelBuilder<TModel extends IObservable<BaseEvent>,
    TEvent extends BaseEvent> extends StatefulWidget {
  final TModel model;
  final Widget Function(BuildContext context, TModel model,
      TEvent? previousEvent, TEvent? event) builder;
  final bool Function(TModel model, TEvent? previous, TEvent? current)?
      buildWhen;
  final void Function(TEvent? previous, TEvent? current)? listener;

  const ModelBuilder(
      {required this.model,
      required this.builder,
      this.buildWhen,
      this.listener});
}
