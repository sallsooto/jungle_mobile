
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jungle/core/config/api-config.dart';
import 'package:http/http.dart' as http;
import 'package:jungle/core/model/club.dart';

class PhotoService{
  final storage = new FlutterSecureStorage();
  final String resUri = ApiConfig.URI + '/api';


  Future<http.Response> getUriPhot() async {
    return http.get(Uri.parse(resUri+'/photos'), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }
  Future<http.Response> getUriPhoto(imageId) async {
    return http.get(Uri.parse(resUri+'/photos/'+imageId), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

}