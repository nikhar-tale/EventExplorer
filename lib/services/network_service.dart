import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/network_response.dart';

class NetworkService {
  NetworkService();

  Future<dynamic> get(String url) async {
    try {
      // ignore: no_leading_underscores_for_local_identifiers
      String _url = url;

      final response = await http.get(
        Uri.parse(_url),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ResponseModel(statusCode: response.statusCode, data: data);
      }

      return ResponseModel(statusCode: response.statusCode, data: null);
    } catch (e) {
      if (e.toString().contains('Failed host lookup')) {
        throw ('NO_CONNECTION');
      } else {
        rethrow;
      }
    }
  }
}
