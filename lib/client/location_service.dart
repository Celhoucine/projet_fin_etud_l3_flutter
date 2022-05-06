import 'dart:convert';
import 'package:http/http.dart' as http;

  Future<http.Response> getLocationData(String text) async {
    http.Response response;

      response = await http.get(
        Uri.parse("http://192.168.1.62:8000/api/place-api-autocomplete?search_text=$text"),
          headers: {"Content-Type": "application/json"},);

    print(jsonDecode(response.body));
    return response;
  }