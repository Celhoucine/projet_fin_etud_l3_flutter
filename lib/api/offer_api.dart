import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class offerApi {
  String baseUrl = 'http://192.168.1.62:8000/api/';
  getofferdata(url,token) async {
    String fullurl = baseUrl + url;
    var response = await http.get(
      Uri.parse(fullurl),headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }
    );
    return response;
  }

  getcategory(url,token) async {
    String fullurl = baseUrl + url;
    var response = await http.get(
      Uri.parse(fullurl) ,headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    }
    );
    return response;
  }


  Future<String> uploadImage(filepath) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.1.62:8000/api/upload'));
    request.files.add(await http.MultipartFile.fromPath('imageFile', filepath));
    var res = await request.send();
    return 'ok';
  }
  getprofile(token,url) async {
    String fullurl = baseUrl + url;
    var response = await http.get(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return response;
  }
    updateprofile(token,url,data) async {
    String fullurl = baseUrl + url;
    var response = await http.post(Uri.parse(fullurl),body: data ,headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return response;
  }
  adddata(token,url,data) async {
    String fullurl = baseUrl + url;
    var response = await http.post(Uri.parse(fullurl),body: data ,headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return response;
  }
}
