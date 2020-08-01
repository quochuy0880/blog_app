//import 'dart:convert';

import 'package:http/http.dart' as http;

class Repository {
  String _baseUrl = "http://localhost:8000/api";

  httpGet(String api) async {
    return await http.get(_baseUrl + "/" + api);
  }
}
