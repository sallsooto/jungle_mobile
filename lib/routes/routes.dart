import 'package:jungle/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Routes {
  final _storage = new FlutterSecureStorage();
  static const String home = '/home';
  static const String login = '/login';
  static const String logout = '/logout';
  static const specialites = '/specialites';
  static const medecins = '/medecins';
  static const patients = '/patients';
  static const meetings = '/meetings';
  MaterialPageRoute makeNamedRoute(
      BuildContext context, RouteSettings settings) {
    if (settings.name == home || settings.name == '/' || settings.name == '/home' ) {
      return MaterialPageRoute(builder: (context) => MyHomePage());
    }




    if (settings.name == logout || settings.name == login) {
      _storage.delete(key: 'token');
      _storage.delete(key: 'userDetails');
      _storage.delete(key: 'matricule');
      return MaterialPageRoute(builder: (context) => MyApp());
    }

    return MaterialPageRoute(builder: (context) => MyApp());
  }
}
