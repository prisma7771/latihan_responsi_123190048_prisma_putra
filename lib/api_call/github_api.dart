import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latihan_responsi_123190048/model_user_api/github_user_model.dart';
import 'package:latihan_responsi_123190048/model_user_api/github_user_repos_model.dart';

class GithubAPI {
  static const String baseUrl = "https://api.github.com";
  static Future<Map<String, dynamic>> get(String partUrl) async {
    var uname = 'username';
    var pword = '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';
    var authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));

    final String fullUrl = baseUrl + "/" + partUrl;
    ("BaseNetwork - fullUrl : $fullUrl");
    final response = await http.get(Uri.parse(fullUrl),headers: {'Authorization': authn});
    ("BaseNetwork - response : ${response.body}");
    return _processResponse(response);
  }
  static Future<Map<String, dynamic>> _processResponse(
      http.Response response) async {
    final body = response.body;
    if (body.isNotEmpty) {
      final jsonBody = json.decode(body);
      return jsonBody;
    } else {
      ("processResponse error");
      return {"error": true};
    }
  }

  static Future<List<UserReposModel>> getRepos(String partUrl) async {
    var uname = 'username';
    var pword = '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';
    var authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));

    final String fullUrl = baseUrl + "/" + partUrl;
    ("BaseNetwork - fullUrl : $fullUrl");
    final response = await http.get(Uri.parse(fullUrl),headers: {'Authorization': authn});
    // ("BaseNetwork - response : ${response.body}");
    return _processResponse2(response);
  }
  static Future<List<UserReposModel>> _processResponse2(
      http.Response response) async {
      final body = response.body;
      List jsonResponse = json.decode(body);
      return jsonResponse
            .map((p) => UserReposModel.fromJson(p))
            .toList();
}

  static Future<List<UserDetailModel>> getFollowers(String partUrl) async {
    var uname = 'username';
    var pword = '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';
    var authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));

    final String fullUrl = baseUrl + "/" + partUrl;
    ("BaseNetwork - fullUrl : $fullUrl");
    final response = await http.get(Uri.parse(fullUrl),headers: {'Authorization': authn});
    // ("BaseNetwork - response : ${response.body}");
    return _processResponse3(response);
  }
  static Future<List<UserDetailModel>> _processResponse3(
      http.Response response) async {
    final body = response.body;
    List jsonResponse = json.decode(body);
    return jsonResponse
        .map((p) => UserDetailModel.fromJson(p))
        .toList();
  }

  static void debugPrint(String value) {
    ("[BASE_NETWORK] - $value");
  }
}