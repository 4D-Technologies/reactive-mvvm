import '../reactive_mvvm.dart';

enum ListChangeTypes { update, add, remove, create }

class ListChangedEvent<TElement> extends BaseEvent {
  final ListChangeTypes change;
  final Iterable<TElement> elements;

  ListChangedEvent({required this.change, required this.elements});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ListChangedEvent<TElement> &&
        other.change == change &&
        other.elements == elements;
  }

  @override
  int get hashCode => change.hashCode ^ elements.hashCode;
}
