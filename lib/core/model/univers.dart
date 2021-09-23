import 'dart:convert';
import 'dart:typed_data';

class Univers {
   int id;
   String nom;
   String description;
   bool etat;

  Univers(this.id, this.nom,this.description,this.etat);

  Univers.fromJson(Map<String, dynamic> json){
       id = json['id'];
        nom = json['nom'];
        description = json['description'];
        etat = json['etat'];
       }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'description': description,
    'etat': etat,
  };
}