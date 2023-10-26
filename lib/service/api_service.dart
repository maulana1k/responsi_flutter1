import 'dart:convert';

import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl = 'https://responsi1b.dalhaqq.xyz/api';

  static Future<http.Response> getAll() {
    return http.get(Uri.parse('$baseUrl/assignments'));
  }

  static Future<http.Response> getById(int id) {
    return http.get(Uri.parse('$baseUrl/assignments/$id'));
  }

  static Future<http.Response> create(Object body) {
    String jsonBody = jsonEncode(body);
    return http.post(Uri.parse('$baseUrl/assignments'),
        headers: {'Content-Type': 'application/json'}, body: jsonBody);
  }

  static Future<http.Response> update(int id, Object body) {
    String jsonBody = jsonEncode(body);
    return http.post(Uri.parse('$baseUrl/assignments/$id/update'),
        headers: {'Content-Type': 'application/json'}, body: jsonBody);
  }

  static Future<http.Response> delete(int id) {
    return http.post(Uri.parse('$baseUrl/assignments/$id/delete'));
  }
}
