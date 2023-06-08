import 'package:api/api.dart';

void main() async {
  await API.init(8097);
  final API api = API();

  print("get /list");
  final Data d1 = await api.list();
  for (Item item in d1.items) {
    print(item);
  }

  print("get /add");
  assert(
    await api.add(
      Item(
        title: "Me",
        path: "https://github.com/Greateapot",
        type: ItemType.link,
      ),
    ),
  );

  print("get /list");
  final Data d2 = await api.list();
  for (Item item in d2.items) {
    print(item);
  }

  print("get /del");
  assert(await api.del("Me"));

  print("get /list");
  final Data d3 = await api.list();
  for (Item item in d3.items) {
    print(item);
  }

  print("get /online");
  final Online online = await api.online();
  for (String ip in online.online) {
    print(ip);
  }
}
