import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../reactive_mvvm.dart';

abstract class WidgetModel<TEvent> with IObservable<TEvent> {
  @protected
  final eventSubject = BehaviorSubject<TEvent>();

  WidgetModel();

  @mustCallSuper
  void dispose() {
    eventSubject.close();
  }

  Stream<TEvent> get changes => eventSubject.stream.asBroadcastStream();

  void raiseEvent(TEvent event) => eventSubject.sink.add(event);
}
