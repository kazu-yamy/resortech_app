import 'package:http/http.dart' as http;

class ResortechRepository {
  static postImage(String imagePath) async {
    final url = Uri.parse('http://192.168.10.2:8000/api/v1/predict');
    final request = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('image', imagePath);

    request.files.add(file);

    try {
      final response = await request.send();
      return await http.Response.fromStream(response);
    } catch (e) {
      return "error to get response";
    }
  }
}
