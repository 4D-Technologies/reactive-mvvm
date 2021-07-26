class ValidationErrors {
  static const REQUIRED = "required";
  static const MAX_LENGTH = "maxLength";
  static const MIN_LENGTH = "minLength";
  static const NOT_EMPTY = "notEmpty";
  static const PASSWORD_COMPLEXITY = "passwordComplexity";
  static const EMAIL_ADDRESS = "emailAddress";
}

abstract class BaseRule<T> {
  const BaseRule();
  List<String>? validate(T value) => throw UnimplementedError();
}

class Required extends BaseRule<dynamic> {
  @override
  List<String>? validate(dynamic value) {
    if (value == null) return [ValidationErrors.REQUIRED];
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

    return [ValidationErrors.MAX_LENGTH];
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

    return [ValidationErrors.MIN_LENGTH];
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
    if (value == null || value.isEmpty) return [ValidationErrors.NOT_EMPTY];

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

    if (value.length < minLength) errors.add(ValidationErrors.MIN_LENGTH);
    if (value.length > maxLength) errors.add(ValidationErrors.MAX_LENGTH);

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
  List<String>? validate(String value) {
    if (!regEx.hasMatch(value)) return [ValidationErrors.EMAIL_ADDRESS];

    return null;
  }
}
