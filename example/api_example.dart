import 'package:api/api.dart';
import 'package:api/models.dart' as models;

void main() async {
  await API.init(8097);
  final API api = API();

  print("get /list");
  final models.Data d1 = await api.list();
  for (models.Item item in d1.items) {
    print(item);
  }

  print("get /add");
  assert(
    await api.add(
      models.Item(
        title: "Me",
        path: "https://github.com/Greateapot",
        type: models.ItemType.link,
      ),
    ),
  );

  print("get /list");
  final models.Data d2 = await api.list();
  for (models.Item item in d2.items) {
    print(item);
  }

  print("get /del");
  assert(await api.del("Me"));

  print("get /list");
  final models.Data d3 = await api.list();
  for (models.Item item in d3.items) {
    print(item);
  }

  print("get /online");
  final models.Online online = await api.online();
  for (String ip in online.online) {
    print(ip);
  }
}
