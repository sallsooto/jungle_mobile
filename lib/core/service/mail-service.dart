import 'package:jungle/core/config/api-config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
class MailService {
  final storage = new FlutterSecureStorage();
  final String resUri = ApiConfig.URI + '/api';


  Future<http.Response> sendEmail(String email, String titre, String message) async {
    return http.get(Uri.parse(resUri+"/clubs/sendEmail/$email/$titre/$message"),
        headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }



}