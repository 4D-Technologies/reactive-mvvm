part of mvvm;

class TextInputField<TDestination> extends TextFormField {
  final FieldModel<String?, TDestination> field;
  final FocusNode focusNode;

  TextInputField(
      {required this.field,
      required String labelText,
      void Function(String)? onFieldSubmitted,
      ITranslator? translator,
      String? helperText,
      String? hintText,
      int helperMaxLines = 2,
      AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
      Key? key,
      TextEditingController? controller,
      TextInputType? keyboardType,
      TextInputAction? textInputAction,
      TextCapitalization textCapitalization = TextCapitalization.none,
      TextStyle? style,
      StrutStyle? strutStyle,
      TextAlign textAlign = TextAlign.start,
      TextAlignVertical? textAlignVertical,
      TextDirection? textDirection,
      bool readOnly = false,
      ToolbarOptions? toolbarOptions,
      bool? showCursor,
      bool autofocus = false,
      String obscuringCharacter = '•',
      bool obscureText = false,
      bool autocorrect = true,
      SmartDashesType smartDashesType = SmartDashesType.disabled,
      SmartQuotesType smartQuotesType = SmartQuotesType.disabled,
      bool enableSuggestions = true,
      int? maxLines,
      int? minLines,
      bool expands = false,
      int? maxLength,
      List<TextInputFormatter>? inputFormatters,
      bool enabled = true,
      double cursorWidth = 2.0,
      double? cursorHeight,
      Radius? cursorRadius,
      Color? cursorColor,
      BoxHeightStyle selectionHeightStyle = BoxHeightStyle.tight,
      BoxWidthStyle selectionWidthStyle = BoxWidthStyle.tight,
      Brightness? keyboardAppearance,
      EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
      bool enableInteractiveSelection = true,
      TextSelectionControls? selectionControls,
      GestureTapCallback? onTap,
      InputCounterWidgetBuilder? buildCounter,
      ScrollController? scrollController,
      ScrollPhysics? scrollPhysics,
      Iterable<String>? autofillHints,
      String? restorationId,
      MaxLengthEnforcement? maxLengthEnforcement,
      FocusNode? focusNode})
      : this.focusNode = focusNode ?? FocusNode(),
        super(
          initialValue: field.sourceValue,
          autocorrect: autocorrect,
          autofillHints: autofillHints,
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          buildCounter: buildCounter,
          controller: controller,
          cursorColor: cursorColor,
          cursorHeight: cursorHeight,
          cursorRadius: cursorRadius,
          cursorWidth: cursorWidth,
          enableInteractiveSelection: enableInteractiveSelection,
          decoration: InputDecoration(
              labelText: labelText,
              helperText: helperText,
              helperMaxLines: helperMaxLines,
              hintText: hintText),
          enableSuggestions: enableSuggestions,
          enabled: enabled,
          expands: expands,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          key: key,
          keyboardAppearance: keyboardAppearance,
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLengthEnforcement: maxLengthEnforcement,
          maxLines: !obscureText ? maxLines : 1,
          minLines: minLines,
          obscureText: obscureText,
          obscuringCharacter: obscuringCharacter,
          onChanged: field.setValue,
          onFieldSubmitted: (value) {
            field.post();
            if (onFieldSubmitted != null) onFieldSubmitted(value);
          },
          onSaved: (value) => field.post(),
          onTap: onTap,
          readOnly: readOnly,
          scrollPadding: scrollPadding,
          scrollPhysics: scrollPhysics,
          selectionControls: selectionControls,
          showCursor: showCursor,
          smartDashesType: smartDashesType,
          smartQuotesType: smartQuotesType,
          strutStyle: strutStyle,
          style: style,
          textAlign: textAlign,
          textAlignVertical: textAlignVertical,
          textCapitalization: textCapitalization,
          textDirection: textDirection,
          textInputAction: textInputAction,
          toolbarOptions: toolbarOptions,
          validator: (value) => field.validator(value, translator: translator),
        ) {
    this.focusNode.addListener(onFocusNode);
  }

  void dispose() {
    this.focusNode.removeListener(onFocusNode);
  }

  void onFocusNode() {
    if (!this.focusNode.hasFocus) this.field.post();
  }
}
