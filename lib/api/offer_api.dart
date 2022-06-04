import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projet_fin_etud_l3_flutter/agence/changepassword.dart';

class offerApi {
  ////// change 192.168.1.62 -> votre IP
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

  getprofile(token, url) async {
    String fullurl = baseUrl + url;
    var response = await http.get(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return response;
  }

  updateprofileagence(token, url, data, image) async {
    String fullurl = baseUrl + url;
    var request = http.MultipartRequest('POST', Uri.parse(fullurl));
    if (image.isNotEmpty) {
      request.files
          .add(await http.MultipartFile.fromPath('imageFile', image[0].path));
    }
    request.fields['fname'] = data['fname'];
    request.fields['lname'] = data['lname'];
    request.fields['phone'] = data['phone'];
    request.fields['email'] = data['email'];
    request.fields['address'] = data['address'];
    request.fields['agenceName'] = data['agenceName'];

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    });

    var response = await request.send();
    print(response);
    return response;
  }

  updateprofileclient(token, url, data, image) async {
    String fullurl = baseUrl + url;
    var request = http.MultipartRequest('POST', Uri.parse(fullurl));
    if (image.isNotEmpty) {
      request.files
          .add(await http.MultipartFile.fromPath('imageFile', image[0].path));
    }
    request.fields['fname'] = data['fname'];
    request.fields['lname'] = data['lname'];
    request.fields['phone'] = data['phone'];
    request.fields['email'] = data['email'];

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data'
    });

    var response = await request.send();
    print(response);
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
    request.fields['latitude'] = data['latitude'];
    request.fields['longitude'] = data['longitude'];
    request.fields['willaya'] = data['willaya'];
    request.fields['baladiya'] = data['baladiya'];
    request.fields['bathroom'] = data['bathroom'].toString();
    request.fields['garage'] = data['garage'].toString();
    request.fields['bedroom'] = data['bedroom'].toString();
    request.fields['livingroom'] = data['livingroom'].toString();
    request.fields['kitchen'] = data['kitchen'].toString();
    request.fields['withimage'] = data['withimage'].toString();
    var response = await request.send();

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
    return response;
  }

  addvue(url, token) async {
    String fullurl = baseUrl + url;
    var response = await http.post(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
  }

  deleteoffer(token, url) async {
    String fullurl = baseUrl + url;
    var response = await http.delete(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
  }

  searchdata(url, token) async {
    String fullurl = baseUrl + url;
    var response = await http.get(Uri.parse(fullurl), headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    return response;
  }
}
