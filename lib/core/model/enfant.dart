import 'package:jungle/core/model/club.dart';
import 'package:jungle/core/model/lieu.dart';
import 'package:jungle/core/model/representant.dart';

class Enfant {
   int id;
   String nom;
   String prenom;
   String telephone;
   String dateNaissance;
   String email;
   String adresse;
   int userId;
   String nom_tuteur;
   String prenom_tuteur;
   String telephone_tuteur;
   String email_tuteur;
   int representant_id;
   Representant representant;

  Enfant({this.id, this.nom,this.adresse,
      this.email,this.dateNaissance,this.prenom,this.telephone,this.userId,
        this.nom_tuteur,this.prenom_tuteur, this.telephone_tuteur, this.email_tuteur,
  this.representant_id,this.representant});

  Enfant.fromJson(Map<String, dynamic> json){
       id = json['id'];
        nom = json['nom'];
        prenom = json['prenom'];
        telephone = json['telephone'];
        dateNaissance = json['dateNaissance'];
        email = json['email'];
        adresse = json['adresse'];
        userId = json['userId'];
        nom_tuteur = json['nom_tuteur'];
        prenom_tuteur = json['prenom_tuteur'];
        telephone_tuteur = json['telephone_tuteur'];
        representant_id = json['representant_id'];
   if (json['representant'] != null) representant = Representant.fromJson(json['representant']);
        email_tuteur = json['email_tuteur'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'telephone': telephone,
    'dateNaissance': dateNaissance,
    'email': email,
    'adresse': adresse,
    'userId': userId,
    'nom_tuteur': nom_tuteur,
    'prenom_tuteur': prenom_tuteur,
    'telephone_tuteur': telephone_tuteur,
    'email_tuteur': email_tuteur,
    'representant_id': representant_id,
    'representant':{
      'id': representant.id
    }
  };
}