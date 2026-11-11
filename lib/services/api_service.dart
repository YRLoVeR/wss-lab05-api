import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:wss_rest_api_use_lab_self/models/user_model.dart';
import 'package:wss_rest_api_use_lab_self/models/post_model.dart';
import 'package:wss_rest_api_use_lab_self/utils/app_contrants.dart';

class ApiService {
  static const Duration timeoutDuration = Duration(seconds: 10);

  Future<List<UserModel>> fetchUsers({int page = 1}) async {
    final uri = Uri.parse('${AppContants.reqResBaseUrl}/users?page=$page');

    try {
      final response = await http.get(uri).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['data'] ?? [];
        return data.map((item) => UserModel.fromjson(item)).toList();
      } else {
        throw Exception(
          'Failed to load users (Status: ${response.statusCode})',
        );
      }
    } on SocketException {
      throw Exception('Network offline. Check your connection.');
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    }
  }

  Future<List<PostModel>> fetchPostsByUser(int userId) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '${AppContants.jsonPlaceholderBaseUrl}/posts?userId=$userId',
            ),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        return decoded.map((item) => PostModel.fromJson(item)).toList();
      } else {
        throw Exception(
          'Failed to load posts (Status: ${response.statusCode})',
        );
      }
    } on SocketException {
      throw Exception('Network offline.');
    } on TimeoutException {
      throw Exception('Connection timed out.');
    }
  }

  Future<Map<String, dynamic>> createPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('${AppContants.jsonPlaceholderBaseUrl}/posts'),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode({'title': title, 'body': body, 'userId': userId}),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
          'Failed to create post (Status: ${response.statusCode})',
        );
      }
    } on SocketException {
      throw Exception('Network offline.');
    } on TimeoutException {
      throw Exception('Connection timed out.');
    }
  }
}
