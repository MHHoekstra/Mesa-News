import 'dart:convert';

import 'package:mesa_news/helpers/http_helper.dart';

class AuthenticationRepository {
  final HttpHelper _httpHelper;
  AuthenticationRepository(this._httpHelper);

  Future<String> signIn(
      {required String email, required String password}) async {
    final body = jsonEncode({"email": email, "password": password});
    final headers = {'Content-Type': 'application/json'};
    final response = await _httpHelper.postRequest(
        'https://mesa-news-api.herokuapp.com/v1/client/auth/signin',
        body,
        headers);
    return response['token'];
  }
}
