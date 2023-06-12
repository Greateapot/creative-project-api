// ignore_for_file: prefer_void_to_null

import 'dart:io';
import 'dart:convert' show utf8;

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
        if (address.startsWith('192.168')) {
          // 192.168.XXX.XXX - стандарт для локальных айпи
          return address;
        }
      }
    }
    throw NoConnectivityException("failed to get local ip");
  }

  Future<http.Response> _rawRequest(
    String path, {
    String? ip,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await client
          .get(Uri.http("${ip ?? this.ip}:$port", path, queryParameters));
    } on http.ClientException catch (e) {
      throw FetchDataException(e.message);
    }
  }

  T _parseResponse<T>(http.Response response) {
    try {
      switch (response.statusCode) {
        case 200: // ok
          if (T == Null) {
            // TODO: use void
            return null as T;
          } else {
            return models
                .serializer<T>()
                .fromJson(utf8.decode(response.bodyBytes));
          }
        case 400: // bad request
        case 403: // forbidden
        case 418: // teapot
        case 500: // internal server err
        default:
          throw models
              .serializer<models.Error>()
              .fromJson(utf8.decode(response.bodyBytes));
      }
    } on FormatException {
      throw Exception("ParsingDataException: can't parse response data.");
    }
  }

  Future<T> _makeRequest<T>(
    String path, {
    String? ip,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _parseResponse<T>(await _rawRequest(
      path,
      ip: ip,
      queryParameters: queryParameters,
    ));
  }

  Future<models.Items> list([String? ip]) async {
    return await _makeRequest<models.Items>(
      '/list',
      ip: ip,
    );
  }

  Future<void> add(models.Item item) async {
    await _makeRequest<Null>(
      '/add',
      queryParameters: models
          .serializer<models.Item>()
          .toMap(item)
          .map((key, value) => MapEntry(key, value.toString())),
    );
  }

  Future<void> del(String title) async {
    await _makeRequest<Null>(
      '/del',
      queryParameters: {"title": title},
    );
  }

  Future<models.Online> online() async {
    return await _makeRequest<models.Online>('/online');
  }

  Future<void> shutdown() async {
    await _makeRequest<Null>('/shutdown');
  }

  Future<models.Link> getLink(String title, [String? ip]) async {
    return await _makeRequest<models.Link>(
      '/get',
      ip: ip,
      queryParameters: {'title': title},
    );
  }

  Future<void> downloadFile(String title, String path, [String? ip]) async {
    http.Response response = await _rawRequest(
      '/get',
      ip: ip,
      queryParameters: {"title": title},
    );

    if (response.statusCode == 200) {
      await File(path).writeAsBytes(response.bodyBytes);
    } else {
      _parseResponse(response); // оно само вызовет ошибку, не 200 же.
    }
  }
}
