import 'package:jungle/core/model/univers.dart';

class SousUnivers {
   int id;
   String nom;
   bool displayInHome;
   String lien;
   Univers univers;

  SousUnivers(this.id, this.nom,this.displayInHome,this.lien,this.univers);

  SousUnivers.fromJson(Map<String, dynamic> json){
    id = json['id'];
    nom = json['nom'];
    displayInHome = json['displayInHome'];
    lien = json['lien'];
    if (json['univers'] != null) univers = Univers.fromJson(json['univers']);

  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'displayInHome': displayInHome,
    'lien': lien,
    'univers':{
      'id': univers.id
    }
  };
}