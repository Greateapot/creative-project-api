import 'package:api/api.dart';
import 'package:api/models.dart' as models;

void main() async {
  await API.init(8097);
  final API api = API();

  print("get /list");
  final models.Items items1 = await api.list();
  for (models.Item item in items1.items) {
    print(item);
  }

  print("get /add");

  await api.add(
    models.Item(
      title: "Me",
      path: "https://github.com/Greateapot",
      type: models.ItemType.link,
    ),
  );

  print("get /list");
  final models.Items items2 = await api.list();
  for (models.Item item in items2.items) {
    print(item);
  }

  print("get /get");
  final models.Link link = await api.getLink("Me");
  print(link.link);

  print("get /del");
  await api.del("Me");

  print("get /list");
  final models.Items items3 = await api.list();
  for (models.Item item in items3.items) {
    print(item);
  }

  print("get /online");
  final models.Online online = await api.online();
  for (String ip in online.online) {
    print(ip);
  }
}
