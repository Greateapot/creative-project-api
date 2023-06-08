import 'dart:io';
import 'dart:convert' show json;

import 'package:http/http.dart' as http;

import 'models/models.dart' as models;
import 'exceptions.dart';

class API {
  static API? _instance;

  final http.Client client;
  final String ip;
  final int port;

  const API._({
    required this.client,
    required this.ip,
    required this.port,
  });

  factory API() => _instance!;

  static Future<void> init(int port) async {
    _instance ??= API._(
      client: http.Client(),
      ip: await _getLocalIP(),
      port: port,
    );
  }

  static Future<String> _getLocalIP() async {
    for (NetworkInterface interface in await NetworkInterface.list()) {
      for (var address in interface.addresses.map((e) => e.address)) {
        if (address.startsWith('192.168')) return address;
      }
    }
    throw NoConnectivityException("failed to get local ip");
  }

  Uri buildUri(String path, {String? ip}) =>
      Uri.http("${ip ?? this.ip}:$port", path);

  Future<models.Response<T>> _makeRequest<T>(
    String path, {
    String? ip,
    Map<String, dynamic>? data,
  }) async {
    final http.Request request = http.Request("GET", buildUri(path, ip: ip));
    if (data != null) request.body = json.encode(data);

    http.StreamedResponse response;
    try {
      response = await client.send(request);
    } on http.ClientException catch (e) {
      throw NoConnectivityException(e.message);
    }
    switch (response.statusCode) {
      case 200:
        return models.ResponseSerializer<T>()
            .fromJson(await response.stream.bytesToString());
      default:
        throw FetchDataException('StatusCode: ${response.statusCode}');
    }
  }

  Future<models.Data> list([String? ip]) async {
    models.Response<models.Data> response = await _makeRequest<models.Data>(
      '/list',
      ip: ip,
    );

    if (response.ok) {
      return response.data!;
    } else {
      throw InvalidInputException(response.err!.code.toString());
    }
  }

  Future<bool> add(models.Item item) async {
    models.Response response = await _makeRequest(
      '/add',
      data: models.ItemSerializer().toMap(item),
    );

    if (response.ok) {
      return true;
    } else {
      throw InvalidInputException(response.err!.code.toString());
    }
  }

  Future<bool> del(String title) async {
    models.Response response = await _makeRequest(
      '/del',
      data: {"title": models.b64enc(title)},
    );

    if (response.ok) {
      return true;
    } else {
      throw InvalidInputException(response.err!.code.toString());
    }
  }

  Future<models.Online> online() async {
    models.Response<models.Online> response = await _makeRequest<models.Online>(
      '/online',
    );

    if (response.ok) {
      return response.data!;
    } else {
      throw InvalidInputException(response.err!.code.toString());
    }
  }
}
