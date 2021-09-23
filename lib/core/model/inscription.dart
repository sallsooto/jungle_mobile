import 'package:jungle/core/model/activite.dart';
import 'package:jungle/core/model/enfant.dart';



class Inscription {
   int id;
   String dateInscription;
   bool status;
   Activite activite;
   Enfant enfant;


  Inscription({this.id, this.activite,this.dateInscription,
                this.enfant,this.status});

  Inscription.fromJson(Map<String, dynamic> json){
      id = json['id'];
    activite = json['activite'];
    dateInscription = json['dateInscription'];
    if (json['activite'] != null) activite = Activite.fromJson(json['activite']);
    if (json['enfant'] != null) enfant = Enfant.fromJson(json['enfant']);
    status = json['status'];
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'dateInscription': dateInscription,
    'status': status,
    'activite':{
      'id': activite.id
    },
    'enfant':{
      'id': enfant.id
    }
  };
}