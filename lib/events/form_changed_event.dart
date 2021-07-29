part of mvvm;

class FormChangedEvent extends BaseEvent {
  final FormModel form;
  final Iterable<IObservable<BaseEvent>> observables;
  final FormStatus status;
  final String? errorMessage;

  FormChangedEvent({
    required this.form,
    this.observables = const [],
    required this.status,
    this.errorMessage,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FormChangedEvent &&
        other.observables == observables &&
        other.status == status &&
        other.errorMessage == errorMessage &&
        other.form == form;
  }

  @override
  int get hashCode {
    return observables.hashCode ^
        status.hashCode ^
        errorMessage.hashCode ^
        form.hashCode;
  }
}
