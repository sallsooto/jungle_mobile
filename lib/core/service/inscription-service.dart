import 'package:jungle/core/config//api-config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jungle/core/model/inscription.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';


class InscriptionService {
  List<Inscription> inscriptions=[];
  final storage = new FlutterSecureStorage();
  final String resUri = ApiConfig.URI + '/api';


  Future<http.Response> createInscription(Inscription inscription) async {
    final String resUri = ApiConfig.URI + '/api/inscriptions';
    return http.post(Uri.parse(resUri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(inscription.toJson()));
  }

  Future<http.Response> updateInscription(Inscription inscription) async {
    final String resUri = ApiConfig.URI + '/api/inscriptions';
    return http.put(Uri.parse(resUri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(inscription.toJson()));
  }

  Future<http.Response> getInscriptions() async {
    final token = await storage.read(key: 'token').then((value) => value);
    return http.get(Uri.parse(resUri+'/inscriptions'), headers: {
      HttpHeaders.authorizationHeader: "Bearer " + token,
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }
}
