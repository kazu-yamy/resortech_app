import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ResortechRepository {
  static Future<http.Response> postImage(String imagePath) async {
    final url = Uri.parse('http://10.47.169.49:8000/api/v1/predict');
    final request = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('image', imagePath);

    request.files.add(file);

    final response = await request.send();
    debugPrint("djshfkjahdkjsfhakjsdhfkjahsdflkjahdkjfhadf");
    return await http.Response.fromStream(response);
  }
}
