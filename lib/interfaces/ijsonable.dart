part of mvvm;

mixin IJsonable {
  String toJsonString() => jsonEncode(toJson());
  Map<String, dynamic> toJson();
}
