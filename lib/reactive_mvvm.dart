library mvvm;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

part './events/base_event.dart';
part './events/base_field_event.dart';
part './events/field_changed_event.dart';
part './events/field_created_event.dart';
part './events/field_posted_event.dart';
part './events/form_changed_event.dart';
part './events/view_changed_event.dart';
part './events/list_changed_event.dart';
part './events/object_changed_event.dart';

part './models/widget_model.dart';
part './models/field_model.dart';
part './models/view_model.dart';
part './models/form_model.dart';
part './models/object_model.dart';

part './validation/rules.dart';

part './observables/observable_list.dart';
part './observables/observable.dart';

part './builders/model_builder.dart';
part './builders/page_model_builder.dart';
part './builders/form_model_builder.dart';
part './builders/list_builder.dart';
part './builders/form_field_model_builder.dart';
part './builders/widget_model_builder.dart';
part './builders/object_model_builder.dart';
part './builders/view_model_builder.dart';
part './builders/field_model_builder.dart';

part './controls/text_input_field.dart';
part './controls/switch_input_field.dart';
part './controls/dropdown_input_field.dart';
part './controls/mvvm_form.dart';
part './controls/number_input_field.dart';
part './controls/checkbox_input_field.dart';

part './interfaces/itranslator.dart';

class ValidationErrorsLocalized {
  static var REQUIRED = "Please enter a value";
  static var MAX_LENGTH = "Please enter a value no longer than {{0}}";
  static var MIN_LENGTH = "Please enter a value no shorter than {{0}}";
  static var NOT_EMPTY = REQUIRED;
  static var PASSWORD_COMPLEXITY =
      "Please ensure that the password contains at least 1 upper case, 1 lower case, 1 number and one special character.";
  static var EMAIL_ADDRESS = "Please enter a valid email address";
  static var URL = "Please enter a valid URL";
}
