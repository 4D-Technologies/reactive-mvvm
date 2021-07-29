part of mvvm;

class FieldModel<TSource, TValue>
    extends WidgetModel<BaseFieldEvent<TSource, TValue>> {
  Iterable<String> errors = [];
  final Iterable<BaseRule<dynamic>> rules;
  TValue _value;
  late TSource _internalValue;

  FieldModel({required TValue initialValue, this.rules = const []})
      : _value = initialValue {
    _internalValue = _getSourceValue(initialValue);
  }

  TValue get value => _value;

  TSource get sourceValue => _getSourceValue(_value);

  void setExternaValue(TValue value) {
    if (_value == value) return;

    _internalValue = _getSourceValue(value);

    if (value == null && !_nullable) {
      errors = [ValidationErrors.REQUIRED];
      return;
    }

    _value = value;
    errors = validate(value);

    eventSubject.sink
        .add(FieldChangedEvent(this, _value, FieldChangeSource.external));
  }

  void setValue(TSource value,
      {FieldChangeSource source = FieldChangeSource.entryChange}) {
    if (value == _internalValue) return;

    _internalValue = value;

    final val = _getValue(value);

    if (val == null && !_nullable) {
      errors = [ValidationErrors.REQUIRED];
      return;
    }

    _value = val!;
    errors = validate(val);

    eventSubject.sink.add(FieldChangedEvent(this, _value, source));
  }

  void post({TSource? value}) {
    if (value == _internalValue) return;

    _internalValue = value ?? _internalValue;

    final val = _getValue(_internalValue);

    if (val == null && !_nullable) {
      errors = [ValidationErrors.REQUIRED];
    } else {
      _value = val!;
      errors = validate(val);
    }

    eventSubject.sink.add(FieldPostedEvent(this, _value));
  }

  Iterable<String> validate([TValue? value]) {
    value ??= _value;
    final errs = List<String>.empty(growable: true);
    rules.forEach((r) {
      final error = r.validate(value);
      if (error != null) errs.addAll(error);
    });

    return errs;
  }

  bool get valid => errors.isEmpty;

  String? validator(dynamic value, {ITranslator? translator}) {
    final val = _getValue(value);

    final errors = validate(val);

    if (errors.isEmpty) return null;

    return errors
        .map((e) => translator == null ? e.toString() : translator.translate(e))
        .join(",");
  }

  Type _type<T>() => T;

  bool get _nullable => _type<TValue?>() == TValue;

  TValue? _getValue(dynamic value) {
    if (value == null && !_nullable) {
      throw UnsupportedError('The value cannot be null');
    } else if (value == null) {
      return null;
    }

    if (TValue == TSource) return value as TValue;

    if (value is String) {
      TValue? result;
      if (TValue == String || TValue == _type<String?>()) {
        result = value as TValue;
      } else if (TValue == DateTime || TValue == _type<DateTime?>()) {
        result = DateTime.tryParse(value) as TValue;
      } else if (TValue == double || TValue == _type<double?>()) {
        result = (double.tryParse(value) as TValue) ?? 0.0 as TValue;
      } else if (TValue == int || TValue == _type<int?>()) {
        result = int.tryParse(value) as TValue ?? 0 as TValue;
      } else if (TValue == num || TValue == _type<num?>()) {
        result = num.tryParse(value) as TValue ?? 0.0 as TValue;
      } else {
        throw UnsupportedError(
            'The Type is not supported: ${TValue.runtimeType.toString()}.');
      }

      if (result == null && rules.any((element) => element is Required)) {
        throw UnsupportedError(
            'Value could not be converted to destination type');
      }

      return result!;
    } else if (TValue is String) {
      return value.toString() as TValue;
    } else if (value.runtimeType == TValue) {
      return value as TValue;
    } else {
      throw UnsupportedError(
          ("We don't support anything but the same source and destination or source as string."));
    }
  }

  TSource _getSourceValue(TValue value) {
    if (value == null) {
      if (TSource == String) return "" as TSource;
    }

    if (TSource == TValue || _type<TSource?>() == TValue) {
      return value as TSource;
    }

    if (TSource == String) {
      if (TValue == double || TValue == int || TValue == num) {
        return value.toString() as TSource;
      } else if (TValue == DateTime) {
        return value.toString() as TSource;
      } else if (TValue == Duration) {
        return value.toString() as TSource;
      } //Later this will look for formatting options.
      else {
        return value.toString() as TSource;
      }
    } else {
      throw UnsupportedError(
          'The Type is not supported: ${TSource.runtimeType.toString()}.');
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FieldModel<TSource, TValue> &&
        other.rules == rules &&
        other._value == _value;
  }

  @override
  int get hashCode {
    return rules.hashCode ^ _value.hashCode;
  }
}
