part of mvvm;

class MvvmForm extends Form {
  final Future<bool> Function() save;
  MvvmForm(
      {GlobalKey<MvvmFormState>? key,
      required Widget child,
      required this.save,
      AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction})
      : super(
          child: child,
          autovalidateMode: autovalidateMode,
          key: key ?? GlobalKey<MvvmFormState>(),
        );

  @override
  FormState createState() {
    return MvvmFormState();
  }
}

class MvvmFormState extends FormState {
  @override
  Future<bool> save() {
    if (!validate()) return Future.value(false);

    super.save();

    final form = this.widget as MvvmForm;

    return form.save();
  }
}
