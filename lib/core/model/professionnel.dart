import 'package:jungle/core/model/club.dart';
import 'package:jungle/core/model/lieu.dart';
import 'package:jungle/core/model/specialite.dart';

class Professionnel {
  int id;
  String nom;
  String prenom;
  String telephone;
  String dateNaissance;
  String email;
  String adresse;
  int userId;
  Club clubProfessionel;
  Specialite specialite;

  Professionnel({this.id, this.nom,this.adresse,
      this.email,this.dateNaissance,this.prenom,
      this.telephone,this.userId,this.specialite,this.clubProfessionel});

  Professionnel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nom = json['nom'],
        prenom = json['prenom'],
        telephone = json['telephone'],
        dateNaissance = json['dateNaissance'],
        email = json['email'],
        adresse = json['adresse'],
        userId = json['userId'],
        clubProfessionel = json['clubProfessionel'],
        specialite = json['specialite'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'telephone': telephone,
    'dateNaissance': dateNaissance,
    'email': email,
    'adresse': adresse,
    'userId': userId,
    'clubProfessionel': clubProfessionel,
    'specialite': specialite
  };
}