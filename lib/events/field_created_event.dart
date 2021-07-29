part of mvvm;

class FieldCreatedEvent<TSource, TValue>
    extends BaseFieldEvent<TSource, TValue> {
  const FieldCreatedEvent(FieldModel<TSource, TValue> model, TValue value)
      : super(model, value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FieldCreatedEvent<TSource, TValue> &&
        other.model == model &&
        other.value == value;
  }

  @override
  int get hashCode => model.hashCode ^ value.hashCode;
}
