part of mvvm;

class TriStateCheckboxInputField extends FormField<bool?> {
  TriStateCheckboxInputField({
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    bool enabled = true,
    Key? key,
    required FieldModel<bool?, bool?> field,
    required String title,
    String? helperText,
    int helperMaxLines = 1,
    Color? activeColor,
    Color? tileColor,
    Color? selectedTileColor,
    Icon? icon,
    bool isThreeLine = false,
    EdgeInsetsGeometry? padding,
    ShapeBorder? shape,
    bool dense = false,
    bool autoFocus = false,
    bool selected = false,
    ListTileControlAffinity controlAffinity = ListTileControlAffinity.platform,
  }) : super(
          autovalidateMode: autovalidateMode,
          enabled: enabled,
          initialValue: field.value,
          key: key,
          onSaved: (newValue) => field.post(value: newValue ?? false),
          validator: field.validator,
          builder: (state) => CheckboxListTile(
            value: field.value,
            tristate: true,
            onChanged: (bool? newValue) {
              field.post(value: newValue);
              state.didChange(newValue);
            },
            title: Text(title),
            activeColor: activeColor,
            secondary: icon,
            isThreeLine: isThreeLine,
            subtitle: helperText == null
                ? null
                : Text(
                    helperText,
                    maxLines: helperMaxLines,
                  ),
            tileColor: tileColor,
            contentPadding: padding,
            selectedTileColor: selectedTileColor,
            key: key,
            shape: shape,
            dense: dense,
            autofocus: autoFocus,
            selected: selected,
            controlAffinity: controlAffinity,
          ),
        );
}
