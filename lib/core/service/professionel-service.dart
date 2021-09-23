import 'package:jungle/core/config/api-config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jungle/core/model/key-professionnel.dart';
import 'package:jungle/core/model/professionnel.dart';
import 'package:jungle/core/model/user.dart';
import 'package:jungle/core/service/key-professionnel-service.dart';
import 'package:jungle/core/service/user-service.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:jungle/core/util/AuthoritiesConstant.dart';


class ProfessionelService {
  final storage = new FlutterSecureStorage();
  UserService userService=new UserService();
  KeyProfessionnelService keyProfessionnelService = new KeyProfessionnelService();
  User user;
  final String resUri = ApiConfig.URI + '/api';
  List<KeyProfessionnel> keyProfessionnels = [];
  KeyProfessionnel keyProfessionnel;


  Future<http.Response> updateProfessionnel(Professionnel professionnel,String loginUser,String passwordUser) async {
    final String resUri = ApiConfig.URI + '/api/professionels';
    chargerKeyProfessionnels();
    print('dans update professionnel');
    user=new User(lastName: professionnel.nom,firstName: professionnel.prenom,email: loginUser,
        login: loginUser,password: passwordUser, langKey: 'fr');
    await userService.createUserProfessionnel(user).then((value) async =>
    {
      if(value.statusCode==HttpStatus.created || value.statusCode==HttpStatus.ok){
        print(value.body),
        user=User.fromJson(jsonDecode(value.body)),
        print('le role'),
        print(user.authorities),

        professionnel.userId=user.id,
        await http.put(Uri.parse(resUri),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode(professionnel.toJson())).then((value) async => {
              keyProfessionnel=new KeyProfessionnel(),
               keyProfessionnels.forEach((element) {
                 if(element.professionel_id==Professionnel.fromJson(jsonDecode(value.body)).id){
                   keyProfessionnel=element;
                 }
               }),
                keyProfessionnel.valid=false,
                await keyProfessionnelService.updateKeyProfessionnel(keyProfessionnel).then((value) => null)

        },onError: (e){print("erreur Professionnel"+e);}),
      }
      else
        print(value.body)
    },
        onError: (e){print("erreur User"+e);
        });
  }

  Future<http.Response> getProfessionnels() async {
    return http.get(Uri.parse(resUri+'/professionels'), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

  chargerKeyProfessionnels() async {
    await keyProfessionnelService.getKeyProfessionnels().then((response) =>
    {
      if(response.body!=null && response.body!=""){
          keyProfessionnels = (jsonDecode(response.body).
          map((i) => KeyProfessionnel.fromJson(i)).toList())
              .cast<KeyProfessionnel>().toList(),
        print('taille key professionnels '+ keyProfessionnels.length.toString())
      }
    });
  }

}
