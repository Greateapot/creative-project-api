library api.models;

import 'dart:convert' show json;

part 'items.dart';
part 'item.dart';
part 'error.dart';
part 'online.dart';
part 'link.dart';

Serializer serializer<T>() {
  switch (T) {
    case Item:
      return ItemSerializer();
    case Items:
      return ItemsSerializer();
    case Error:
      return ErrorSerializer();
    case Online:
      return OnlineSerializer();
    case Link:
      return LinkSerializer();
    default:
      throw Exception("Serializer for type $T not found");
  }
}

abstract class Serializer<T> {
  String toJson(T obj) => json.encode(toMap(obj));

  Map<String, dynamic> toMap(T obj);

  T fromJson(String source) => fromMap(json.decode(source));

  T fromMap(Map<String, dynamic> map);
}
