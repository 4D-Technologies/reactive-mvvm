part of mvvm;

enum ViewStatus {
  loading,
  ready,
  submittingInProgress,
  submissionSuccess,
  submissionError,
  error,
}

abstract class ViewModel extends WidgetModel<BaseEvent> {
  bool hasChanges = false;

  late ViewChangedEvent lastEvent;

  ViewModel(
      {String? errorMessage,
      ViewStatus status = ViewStatus.loading,
      Iterable<IObservable<BaseEvent>>? changes}) {
    lastEvent = ViewChangedEvent(
      status: status,
      errorMessage: errorMessage,
      changes: changes ?? [],
    );
    eventSubject.stream.doOnData((event) => hasChanges = true);
  }

  @override
  Stream<BaseEvent> get changes {
    if (lastEvent.status == ViewStatus.loading) {
      return eventSubject.stream.asBroadcastStream();
    }

    return Rx.merge([
      eventSubject.stream,
      Rx.merge(observables.map((e) => e.changes))
          .transform(_formToViewEventTransformer)
    ]).doOnData((event) => hasChanges = true).asBroadcastStream();
  }

  Iterable<IObservable<BaseEvent>> get observables => [];

  String? get errorMessage => lastEvent.errorMessage;

  ViewStatus get status => lastEvent.status;
  void emit(ViewStatus value,
      {String? errorMessage,
      Exception? exception,
      String? reason,
      Iterable<IObservable<BaseEvent>>? changes}) {
    assert((exception != null && errorMessage == null) ||
        (errorMessage != null && exception == null) ||
        (errorMessage == null && exception == null));

    if (exception != null) {
      if (exception is HttpException) {
        errorMessage = exception.message;
      } else {
        errorMessage = exception.toString();
      }
    }

    if (errorMessage != null &&
        errorMessage.startsWith("{") &&
        errorMessage.endsWith("}")) {
      final json = jsonDecode(errorMessage) as Map<String, dynamic>;
      if (json["errors"] != null) {
        errorMessage = "";
        if (json["errors"] is Map<String, dynamic>) {
          (json["errors"] as Map<String, dynamic>)
              .forEach((key, dynamic value) {
            errorMessage =
                (errorMessage ?? "") + (value as List<dynamic>).join('\n');
          });
        } else {
          errorMessage = (json["errors"] as List<String>).join("\n");
        }
      }
    }

    final newEvent = ViewChangedEvent(
      status: value,
      errorMessage: errorMessage,
      reason: reason,
      changes: changes ?? <IObservable<BaseEvent>>[],
    );

    if (lastEvent == newEvent) return;

    lastEvent = newEvent;

    eventSubject.sink.add(
      lastEvent,
    );

    if (value == ViewStatus.submissionSuccess) hasChanges = false;
  }

  late final _formToViewEventTransformer =
      StreamTransformer<BaseEvent, BaseEvent>.fromHandlers(
    handleData: (e, sink) {
      if (e is FormChangedEvent) {
        ViewStatus status = lastEvent.status;
        String? errorMessage = lastEvent.errorMessage;

        sink.add(
          ViewChangedEvent(
              status: status, changes: [e.form], errorMessage: errorMessage),
        );
      } else {
        sink.add(e);
      }
    },
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ViewModel && other.lastEvent == other.lastEvent;
  }

  @override
  int get hashCode => lastEvent.hashCode;
}
