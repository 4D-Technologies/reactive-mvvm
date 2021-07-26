import '../reactive_mvvm.dart';

abstract class BaseFieldEvent<TSource, TValue> extends BaseEvent {
  final FieldModel<TSource, TValue> model;
  final TValue value;

  const BaseFieldEvent(this.model, this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BaseFieldEvent<TSource, TValue> &&
        other.model == model &&
        other.value == value;
  }

  @override
  int get hashCode => model.hashCode ^ value.hashCode;
}
