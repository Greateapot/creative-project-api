part of api.models;

class Link {
  final String link;

  const Link({required this.link});

  @override
  String toString() => "Link#$hashCode(link: $link)";
}

class LinkSerializer extends Serializer<Link> {
  @override
  Link fromMap(Map<String, dynamic> map) => Link(
        link: map['link'],
      );

  @override
  Map<String, dynamic> toMap(Link obj) => <String, dynamic>{
        "link": obj.link,
      };
}
