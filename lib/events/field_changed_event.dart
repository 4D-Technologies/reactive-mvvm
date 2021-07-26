import '../reactive_mvvm.dart';

class FieldChangedEvent<TSource, TValue>
    extends BaseFieldEvent<TSource, TValue> {
  final FieldChangeSource source;

  const FieldChangedEvent(
      FieldModel<TSource, TValue> model, TValue value, this.source)
      : super(model, value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FieldChangedEvent<TSource, TValue> &&
        other.model == model &&
        other.value == value &&
        other.source == source;
  }

  @override
  int get hashCode => model.hashCode ^ value.hashCode ^ source.hashCode;
}

enum FieldChangeSource { entryChange, external }
