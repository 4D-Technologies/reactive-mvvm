part of mvvm;

abstract class BaseRule<T> {
  const BaseRule();
  List<String>? validate(T value) => throw UnimplementedError();
}

class Required extends BaseRule<dynamic> {
  @override
  List<String>? validate(dynamic value) {
    if (value == null) return [ValidationErrorsLocalized.REQUIRED];
    return null;
  }
}

class MaxLength extends BaseRule<String> {
  final int maxLength;
  const MaxLength(this.maxLength);

  @override
  List<String>? validate(String? value) {
    if (value == null || value.isEmpty || value.length <= maxLength) {
      return null;
    }

    return [
      ValidationErrorsLocalized.MAX_LENGTH
          .replaceAll("{{0}}", maxLength.toString())
    ];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MaxLength && other.maxLength == maxLength;
  }

  @override
  int get hashCode => maxLength.hashCode;
}

class MinLength extends BaseRule<String> {
  final int minLength;
  const MinLength(this.minLength);

  @override
  List<String>? validate(String? value) {
    if (value == null || value.length >= minLength) return null;

    return [
      ValidationErrorsLocalized.MIN_LENGTH
          .replaceAll("{{0}}", minLength.toString())
    ];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MinLength && other.minLength == minLength;
  }

  @override
  int get hashCode => minLength.hashCode;
}

class NotEmpty extends BaseRule<String> {
  @override
  List<String>? validate(String? value) {
    if (value == null || value.isEmpty)
      return [ValidationErrorsLocalized.NOT_EMPTY];

    return null;
  }
}

class StringLength extends BaseRule<String> {
  final int minLength;
  final int maxLength;
  const StringLength(this.minLength, this.maxLength);

  @override
  List<String>? validate(String? value) {
    if (value == null) return null;

    final errors = List<String>.empty(growable: true);

    if (value.length < minLength)
      errors.add(ValidationErrorsLocalized.MIN_LENGTH
          .replaceAll("{{0}}", minLength.toString()));
    if (value.length > maxLength)
      errors.add(ValidationErrorsLocalized.MAX_LENGTH
          .replaceAll("{{0}}", maxLength.toString()));

    if (errors.isEmpty) return null;

    return errors;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StringLength &&
        other.minLength == minLength &&
        other.maxLength == maxLength;
  }

  @override
  int get hashCode => minLength.hashCode ^ maxLength.hashCode;
}

class EmailAddress extends BaseRule<String> {
  static RegExp regEx = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  @override
  List<String>? validate(String? value) {
    if (value != null && !regEx.hasMatch(value))
      return [ValidationErrorsLocalized.EMAIL_ADDRESS];

    return null;
  }
}
