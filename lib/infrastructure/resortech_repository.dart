import 'package:http/http.dart' as http;

class ResortechRepository {
  static postImage(String imagePath) async {
    final url = Uri.parse('https://xxx.xxx.xxx.xxx');
    final request = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('image', imagePath);

    request.files.add(file);

    final response = await request.send();
    return await http.Response.fromStream(response);
  }
}
