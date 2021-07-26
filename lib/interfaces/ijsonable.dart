import 'dart:convert';

mixin IJsonable {
  String toJsonString() => json.encode(toJson());
  Map<String, dynamic> toJson();
}
