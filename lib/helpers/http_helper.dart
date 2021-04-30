import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mesa_news/utils/api_exceptions.dart';

class HttpHelper {
  final Client _httpClient;
  HttpHelper._(this._httpClient);

  static HttpHelper? _instance;
  factory HttpHelper(Client? client) {
    if (_instance == null) {
      _instance = HttpHelper._(client!);
    }
    return _instance!;
  }

  Future<dynamic> getRequest(String url, dynamic headers) async {
    try {
      final uri = Uri.parse(url);
      final Response response = await _httpClient.get(uri, headers: headers);
      var json;
      final statusCode = response.statusCode;
      if (response.body.isNotEmpty) {
        json = await jsonDecode(response.body);
      }
      if (statusCode >= 200 && statusCode < 300) {
        return json;
      } else if (statusCode >= 400 && statusCode < 500) {
        throw ClientErrorException(
            code: statusCode, message: json != null ? json['message'] : '');
      } else if (statusCode >= 400 && statusCode < 500) {
        throw ServerErrorException(
            code: statusCode, message: json != null ? json['message'] : '');
      } else {
        throw UnknownErrorException();
      }
    } on SocketException catch (_) {
      throw ConnectionException();
    }
  }

  Future<dynamic> postRequest(String url, dynamic body, dynamic headers) async {
    try {
      final uri = Uri.parse(url);
      final Response response =
          await _httpClient.post(uri, headers: headers, body: body);
      var json;
      final statusCode = response.statusCode;
      if (response.body.isNotEmpty) {
        json = await jsonDecode(response.body);
      }
      if (statusCode >= 200 && statusCode < 300) {
        return json;
      } else if (statusCode >= 400 && statusCode < 500) {
        throw ClientErrorException(
            code: statusCode, message: json != null ? json['message'] : '');
      } else if (statusCode >= 400 && statusCode < 500) {
        throw ServerErrorException(
            code: statusCode, message: json != null ? json['message'] : '');
      } else {
        throw UnknownErrorException();
      }
    } on SocketException catch (_) {
      throw ConnectionException();
    }
  }
}
