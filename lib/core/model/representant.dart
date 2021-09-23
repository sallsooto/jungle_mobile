import 'package:jungle/core/model/club.dart';
import 'package:jungle/core/model/lieu.dart';

class Representant {
  int id;
  String nom;
  String prenom;
  String telephone;
  String email;
  int user_id;

  Representant({this.id, this.nom,
    this.email,this.prenom,this.telephone,this.user_id,
    });

  Representant.fromJson(Map<String, dynamic> json){
    id = json['id'];
    nom = json['nom'];
    prenom = json['prenom'];
    telephone = json['telephone'];
    email = json['email'];
    user_id = json['user_id'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'telephone': telephone,
    'email': email,
    'user_id': user_id
  };
}