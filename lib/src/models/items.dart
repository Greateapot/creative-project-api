part of api.models;

class Items {
  final List<Item> items;

  const Items({required this.items});

  @override
  String toString() =>
      "Items#$hashCode(items: ${[for (final Item item in items) '$item, ']})";
}

class ItemsSerializer extends Serializer<Items> {
  @override
  Items fromMap(Map<String, dynamic> map) => Items(
        items: map['items'] != null
            ? [
                for (final Map<String, dynamic> v in map['items'])
                  ItemSerializer().fromMap(v),
              ]
            : [],
      );

  @override
  Map<String, dynamic> toMap(Items obj) => <String, dynamic>{
        "items": [
          for (final Item item in obj.items) ItemSerializer().toMap(item)
        ],
      };
}
