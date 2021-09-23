import 'package:jungle/core/config//api-config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jungle/core/model/key-professionnel.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:jungle/core/model/user.dart';

class KeyProfessionnelService {
  List<KeyProfessionnel> keyProfessionnels=[];
  final storage = new FlutterSecureStorage();
  final String resUri = ApiConfig.URI + '/api';



  Future<http.Response> getKeyProfessionnels() async {
    return http.get(Uri.parse(resUri+"/key-professionels?valid.equals=true"), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

  Future<http.Response> updateKeyProfessionnel(KeyProfessionnel keyProfessionnel) async {
    final String resUri = ApiConfig.URI + '/api/key-professionels';
    return http.put(
        Uri.parse(resUri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(keyProfessionnel.toJson())
    );
  }


}
