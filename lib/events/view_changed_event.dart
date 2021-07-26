import '../reactive_mvvm.dart';

class ViewChangedEvent extends BaseEvent {
  final ViewStatus status;
  final String? reason;
  final String? errorMessage;
  final Iterable<IObservable<BaseEvent>> changes;

  ViewChangedEvent({
    this.changes = const [],
    required this.status,
    this.errorMessage,
    this.reason,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ViewChangedEvent &&
        other.changes == changes &&
        other.status == status &&
        other.errorMessage == errorMessage &&
        other.reason == reason;
  }

  @override
  int get hashCode =>
      changes.hashCode ^
      status.hashCode ^
      errorMessage.hashCode ^
      reason.hashCode;
}
