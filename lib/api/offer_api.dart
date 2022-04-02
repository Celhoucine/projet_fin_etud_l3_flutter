import 'package:http/http.dart' as http;

class offerApi {
  String baseUrl = 'http://192.168.1.62:8000/api/';
  getofferdata(url) async {
    String fullurl = baseUrl + url;
    var response = await http.get(
      Uri.parse(fullurl),
    );
    return response;
  }
}
