import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projet_fin_etud_l3_flutter/agence/changepassword.dart';

class offerApi {
  String baseUrl = 'http://192.168.1.62:8000/api/';
  getofferdata(url, token) async {
    String fullurl = baseUrl + url;
    var response = await http.get(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return response;
  }
  

  getcategory(url, token) async {
    String fullurl = baseUrl + url;
    var response = await http.get(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return response;
  }

  Future<String> uploadImage(filepath) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.1.62:8000/api/upload'));
    request.files.add(await http.MultipartFile.fromPath('imageFile', filepath));
    var res = await request.send();
    return 'ok';
  }

  getprofile(token, url) async {
    String fullurl = baseUrl + url;
    var response = await http.get(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return response;
  }

  updateprofile(token, url, data) async {
    String fullurl = baseUrl + url;
    var response = await http.post(Uri.parse(fullurl), body: data, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return response;
  }

  adddata(token, url, data, List image) async {
    String fullurl = baseUrl + url;

    var request = http.MultipartRequest('POST', Uri.parse(fullurl));

    for (var i = 0; i < image.length; i++) {
      request.files
          .add(await http.MultipartFile.fromPath('imageFile[]', image[i].path));
    }
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    });
    request.fields['description'] = data['description'];
    request.fields['prix'] = data['prix'];
    request.fields['surface'] = data['surface'];
    request.fields['categorie'] = data['categorie'];
    var response = await request.send();
    print(response.statusCode);
    return response;
  }

  addfavorite(token, url) async {
    String fullurl = baseUrl + url;
    var response = await http.post(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return response;
  }

  exsistfavorite(token, url) async {
    String fullurl = baseUrl + url;
    var response = await http.get(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    return jsonDecode(response.body);
  }

  changepassword(token, data, url) async {
    String fullurl = baseUrl + url;
    var response = await http.post(Uri.parse(fullurl), body: data, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return response;
  }

  addcomment(token, data, url) async {
    String fullurl = baseUrl + url;
    var response = await http.post(Uri.parse(fullurl), body: data, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return response;
  }
  getoffercomment(url, token) async {
    String fullurl = baseUrl + url;
    var response = await http.get(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return response;
  }
  getoffervues(url, token) async {
    String fullurl = baseUrl + url;
    var response = await http.get(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return jsonDecode(response.body);
  }
   addvue(url, token) async {
    String fullurl = baseUrl + url;
    var response = await http.post(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    
  }
   deleteoffer( token,url) async {
    String fullurl = baseUrl + url;
    var response = await http.delete(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    
  }
  
}
