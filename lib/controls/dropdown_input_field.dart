import 'package:flutter/material.dart';

import '../reactive_mvvm.dart';

class DropDownInputField<TDestination>
    extends DropdownButtonFormField<TDestination> {
  DropDownInputField(
      {required List<DropdownMenuItem<TDestination>> items,
      required FieldModel<TDestination?, TDestination> field,
      required String labelText,
      int hintMaxLines = 1,
      String? hintText,
      bool autofocus = false,
      AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
      Key? key,
      Color? dropdownColor,
      Color? focusColor,
      Color? iconDisabledColor,
      Color? iconEnabledColor,
      String? helperText,
      int helperTextMaxLines = 1,
      int elevation = 8,
      FocusNode? focusNode,
      Widget? icon,
      double iconSize = 24.0,
      bool isDense = false,
      bool isExpanded = false,
      double? itemHeight,
      List<Widget> Function(BuildContext context)? selectedItemBuilder,
      TextStyle? style,
      void Function()? onTap,
      ValueChanged<TDestination?>? onChanged})
      : super(
            items: items,
            autofocus: autofocus,
            autovalidateMode: autovalidateMode,
            decoration: InputDecoration(
                labelText: labelText,
                hintMaxLines: hintMaxLines,
                hintText: hintText),
            dropdownColor: dropdownColor,
            disabledHint: helperText == null
                ? null
                : Text(
                    helperText,
                    maxLines: helperTextMaxLines,
                  ),
            focusColor: focusColor,
            elevation: elevation,
            focusNode: focusNode,
            hint: helperText == null
                ? null
                : Text(
                    helperText,
                    maxLines: helperTextMaxLines,
                  ),
            icon: icon,
            iconSize: iconSize,
            iconDisabledColor: iconDisabledColor,
            iconEnabledColor: iconEnabledColor,
            isDense: isDense,
            key: key,
            isExpanded: isExpanded,
            itemHeight: itemHeight,
            selectedItemBuilder: selectedItemBuilder,
            style: style,
            validator: field.validator,
            value: field.value,
            onChanged: (newValue) {
              field.post(value: newValue);

              if (onChanged != null) {
                onChanged(newValue);
              }
            },
            onSaved: field.setValue,
            onTap: onTap);
}
