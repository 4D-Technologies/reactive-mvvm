part of mvvm;

enum FormStatus { pure, valid, invalid }

abstract class FormModelFromDto<TDto> extends FormModel {
  TDto get dto;

  FormModelFromDto({String? formMessage, FormStatus status = FormStatus.pure})
      : super(formMessage: formMessage, status: status);
}

abstract class FormModel extends WidgetModel<BaseEvent> {
  String? _formMessage;
  FormStatus _status;

  FormModel({String? formMessage, FormStatus status = FormStatus.pure})
      : _status = status,
        _formMessage = formMessage;

  Iterable<IObservable<BaseEvent>> get observables;

  @override
  Stream<BaseEvent> get changes => Rx.merge([
        eventSubject.stream,
        Rx.merge(observables.map((e) => e.changes))
            .transform(_fieldToFormEventTransformer)
      ]).asBroadcastStream();

  String? get formMessage => _formMessage;

  FormStatus get status => _status;
  set status(FormStatus value) {
    if (value == _status) return;

    _status = value;
    eventSubject.sink.add(FormChangedEvent(
        form: this, status: value, errorMessage: _formMessage));
  }

  late final _fieldToFormEventTransformer =
      StreamTransformer<BaseEvent, BaseEvent>.fromHandlers(
    handleData: (e, sink) {
      if (e is FieldPostedEvent) {
        _status = FormStatus.valid;
        _formMessage = null;
        for (final field
            in observables.whereType<FieldModel<dynamic, dynamic>>()) {
          if (field.errors.isNotEmpty) {
            _status = FormStatus.invalid;
            _formMessage = "Validation Failed";
            break;
          }
        }

        sink.add(
          FormChangedEvent(
              form: this,
              status: _status,
              observables: [e.model],
              errorMessage: _formMessage),
        );
      } else {
        sink.add(e);
      }
    },
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FormModel &&
        other._formMessage == _formMessage &&
        other._status == _status &&
        other.observables == observables;
  }

  @override
  int get hashCode =>
      _formMessage.hashCode ^ _status.hashCode ^ observables.hashCode;
}
