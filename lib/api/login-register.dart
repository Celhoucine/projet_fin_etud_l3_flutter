import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:projet_fin_etud_l3_flutter/login.dart';

class auth {
  ////// change 192.168.1.62 -> votre IP
  String baseUrl = 'http://192.168.1.62:8000/api/';
  register(data, url) async {
    String fullurl = baseUrl + url;
    var response = await http.post(Uri.parse(fullurl), body: data, headers: {
      'Accept': 'application/json',
    });
    return response;
  }

  login(data, url) async {
    String fullurl = baseUrl + url;
    var response = await http.post(Uri.parse(fullurl), body: data, headers: {
      'Accept': 'application/json',
    });
    return response;
  }

  logout(token, url) async {
    String fullurl = baseUrl + url;
    var response = await http.delete(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return response;
  }

  loginwithtoken(token, url) async {
    String fullurl = baseUrl + url;
    var response = await http
        .get(Uri.parse(fullurl), headers: {'Authorization': 'Bearer $token'});

    return response;
  }

  addpost(data, url) async {
    String fullurl = baseUrl + url;
    var response = await http.post(Uri.parse(fullurl), body: data, headers: {
      'Accept': 'application/json',
    });
    return response;
  }

  _setheaders(token) {
    var headers = {};
    return headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
  agenceverifcation(url,token) async {
      String fullurl = baseUrl + url;
    var response = await http.get(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return response;
  }
}
