import 'package:http/http.dart' as http;import 'dart:async';
import 'dart:io';

import 'package:jungle/core/config/api-config.dart';

class RoleService{
  final String resUri = ApiConfig.URI + '/api';
  Future<http.Response> getProfessionnels() async {
    return http.get(Uri.parse(resUri+'/professionels'), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

}