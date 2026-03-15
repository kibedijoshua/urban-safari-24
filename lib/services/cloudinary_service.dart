import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class CloudinaryService {
  final String cloudName = 'dg5lzxjcu';
  final String uploadPreset = 'ib6ccmem';

  Future<String> uploadImage(File file) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    final jsonResponse = jsonDecode(responseString);

    if (response.statusCode == 200) {
      return jsonResponse['secure_url'];
    } else {
      throw Exception('Failed to upload image to Cloudinary: ${jsonResponse['error']['message']}');
    }
  }

  Future<String> uploadImageBytes(Uint8List bytes) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(http.MultipartFile.fromBytes('file', bytes, filename: 'upload.jpg'));

    final response = await request.send();
    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    final jsonResponse = jsonDecode(responseString);

    if (response.statusCode == 200) {
      return jsonResponse['secure_url'];
    } else {
      throw Exception('Failed to upload image bytes to Cloudinary: ${jsonResponse['error']['message']}');
    }
  }
}
