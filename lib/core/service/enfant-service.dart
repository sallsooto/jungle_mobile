import 'package:jungle/core/config/api-config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jungle/core/model/enfant.dart';
import 'package:jungle/core/model/representant.dart';
import 'package:jungle/core/model/user.dart';
import 'package:jungle/core/service/user-service.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:jungle/core/util/AuthoritiesConstant.dart';
import 'package:jungle/core/util/DateConverter.dart';


class EnfantService {
  final storage = new FlutterSecureStorage();
  UserService userService=new UserService();
  User user;
  Representant representant;
  final String resUri = ApiConfig.URI + '/api';


  Future<http.Response> createEnfant(Enfant enfant,String loginUser,String passwordUser) async {
    final String resUri = ApiConfig.URI + '/api/enfant-register';
    final String resUriRepresentant = ApiConfig.URI + '/api/representant-register';
    print('dans create enfant');
    if(DateTime.now().year-
        DateConverter.stringToDate(enfant.dateNaissance).year>18){
      print("majeur");
      user=new User(lastName: enfant.nom,firstName: enfant.prenom,email: loginUser,
          login: loginUser,password: passwordUser, langKey: 'fr', authorities: [AuthoritiesConstant.ENFANT]);
      await userService.createUserEnfant(user).then((value) async =>
      {
        if(value.statusCode==HttpStatus.created || value.statusCode==HttpStatus.ok){
          print(value.body),
          user=User.fromJson(jsonDecode(value.body)),
          enfant.userId=user.id,
          await http.post(Uri.parse(resUri),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
              },
              body: jsonEncode(enfant.toJson())).then((value) async => {
            print(value.body),

          },onError: (e){print("erreur Enfant"+e);}),
        }
        else
          print(value.body)
      },
          onError: (e){print("erreur User"+e);
          });

    }
    else {
      print("mineur");
      user=new User(lastName: enfant.nom_tuteur,firstName: enfant.prenom_tuteur,email: enfant.email_tuteur,
          login: enfant.email_tuteur,password: passwordUser, langKey: 'fr', authorities: [AuthoritiesConstant.REPRESENTANT]);
      await userService.createUserRepresentant(user).then((value) async =>
      {
        if(value.statusCode==HttpStatus.created || value.statusCode==HttpStatus.ok){
          print(value.body),
          user=User.fromJson(jsonDecode(value.body)),
          representant= new Representant(nom:enfant.nom_tuteur,prenom: enfant.prenom_tuteur,
                  telephone: enfant.telephone_tuteur,email: enfant.email_tuteur, user_id: user.id),
          await http.post(Uri.parse(resUriRepresentant),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
              },
              body: jsonEncode(representant.toJson())).then((value) async => {
            print(value.body),
            representant=Representant.fromJson(jsonDecode(value.body)),
            enfant.representant_id=representant.id,
            enfant.representant=representant,
            await http.post(Uri.parse(resUri),
                headers: {
                  HttpHeaders.contentTypeHeader: 'application/json',
                },
                body: jsonEncode(enfant.toJson())).then((value) async => {
              print(value.body),

            },onError: (e){print("erreur Enfant"+e);}),

          },onError: (e){print("erreur Representant"+e);}),

        }
        else
          print(value.body)
      },
          onError: (e){print("erreur User"+e);
          });
    }
  }

  Future<http.Response> createEnfantByRepresentant(Enfant enfant,int representantId) async {
    final String resUri = ApiConfig.URI + '/api/enfant-register';
    print('dans create enfant');
    if(DateTime.now().year-
        DateConverter.stringToDate(enfant.dateNaissance).year>18){
      print("majeur");
    }
    else {
      print("mineur");
      enfant.representant_id=representantId;
    await http.post(Uri.parse(resUri),
    headers: {
    HttpHeaders.contentTypeHeader: 'application/json',
    },
    body: jsonEncode(enfant.toJson())).then((value) async => {
    print(value.body),
    },onError: (e){print("erreur Enfant"+e);});
    }
  }


  Future<http.Response> createRepresentant(Representant representant, String passwordUser) async {
    final String resUriRepresentant = ApiConfig.URI + '/api/representant-register';
    user=new User(lastName: representant.nom,firstName: representant.prenom,email: representant.email,
        login: representant.email,password: passwordUser, langKey: 'fr', authorities: [AuthoritiesConstant.REPRESENTANT]);
    await userService.createUserRepresentant(user).then((value) async =>
    {
      if(value.statusCode == HttpStatus.created ||
          value.statusCode == HttpStatus.ok){
        representant.user_id=user.id,
        await http.post(Uri.parse(resUriRepresentant),
        headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(representant.toJson())).then((value) async => {
          print('ajout representant'),
          print(value.body),
        })
      }
      });
    }

  Future<http.Response> getEnfantsByRepresentant(int representantId) async {
    return http.get(Uri.parse(resUri+"/enfants?representant_id.equals=$representantId"), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

  Future<http.Response> getRepresentantByUserId(int userId) async {
    return http.get(Uri.parse(resUri+"/representants?user_id.equals=$userId"), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }
}
