part of api.models;

enum ItemType with Comparable<ItemType> {
  folder(0),
  file(1),
  link(2);

  const ItemType(this.compareValue);

  factory ItemType.fromValue(int v) {
    switch (v) {
      case 1:
        return file;
      case 2:
        return folder;
      case 3:
        return link;
      default:
        throw ArgumentError("No item type with value $v");
    }
  }

  int toValue() {
    switch (this) {
      case file:
        return 1;
      case folder:
        return 2;
      case link:
        return 3;
    }
  }

  final int compareValue;

  @override
  int compareTo(ItemType other) {
    if (compareValue < other.compareValue) {
      return -1;
    } else if (compareValue > other.compareValue) {
      return 1;
    } else {
      return 0;
    }
  }
}

class Item {
  final String title;
  final String? path;
  final ItemType type;

  const Item({required this.title, required this.type, this.path});

  @override
  String toString() =>
      "Item#$hashCode(title: $title, type: $type, path: $path)";

  @override
  bool operator ==(Object other) {
    if (other.runtimeType == Item) {
      Item v = other as Item;
      return title == v.title && type == v.type && path == v.path;
    }
    return false;
  }

  @override
  int get hashCode => title.hashCode * type.toValue() + path.hashCode;
}

class ItemSerializer extends Serializer<Item> {
  @override
  Item fromMap(Map<String, dynamic> map) => Item(
        title: b64dec(map['title']),
        path: map['path'] != null ? b64dec(map['path']) : null,
        type: ItemType.fromValue(map['type']),
      );

  @override
  Map<String, dynamic> toMap(Item obj) => <String, dynamic>{
        "title": b64enc(obj.title),
        "type": obj.type.toValue(),
        if (obj.path != null) "path": b64enc(obj.path!),
      };
}
