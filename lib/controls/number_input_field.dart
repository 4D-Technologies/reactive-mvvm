part of mvvm;

class NumberInputField<TDestination> extends TextInputField<TDestination> {
  NumberInputField({
    required FieldModel<String, TDestination> field,
    required String labelText,
    bool decimal = true,
    bool signed = true,
    bool enabled = true,
  }) : super(
          field: field,
          labelText: labelText,
          keyboardType: TextInputType.numberWithOptions(
            decimal: decimal,
            signed: signed,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                signed ? RegExp('[0-9.,-]') : RegExp('[0-9.,]')),
          ],
          enabled: true,
        );
}
