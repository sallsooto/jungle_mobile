import 'package:jungle/core/model/club.dart';
import 'package:jungle/core/model/lieu.dart';
import 'package:jungle/core/model/type-activite.dart';
import 'package:jungle/core/model/univers.dart';

class Activite {
   int id;
   String nom;
   int age_min;
   int age_max;
   String heureDebut;
   String heureFin;
   Lieu lieu;
   int prix;
   Club clubActivite;
   String date_debut;
   String date_fin;
   String debut_inscription;
   String fin_inscription;
   String description;
   int nombre_participants;
   String modalite_pratique;
   Univers univers;
   TypeActivite typeActivite;

  Activite(this.id, this.nom, this.age_min, this.age_max, this.clubActivite,
      this.heureDebut,this.heureFin,this.lieu,this.prix,
      this.date_debut,this.date_fin, this.debut_inscription, this.fin_inscription,
      this.description
      , this.nombre_participants, this.modalite_pratique, this.univers, typeActivite);

  Activite.fromJson(Map<String, dynamic> json){
       id = json['id'];
        nom = json['nom'];
       age_min = json['age_min'];
       age_max = json['age_max'];
       if (json['clubActivite'] != null) clubActivite = Club.fromJson(json['clubActivite']);
        heureDebut = json['heureDebut'];
        heureFin = json['heureFin'];
        lieu = json['lieu'];
        prix = json['prix'];
        date_debut = json['date_debut'];
        date_fin = json['date_fin'];
        debut_inscription = json['debut_inscription'];
        fin_inscription = json['fin_inscription'];
        description = json['description'];
        nombre_participants = json['nombre_participants'];
        modalite_pratique = json['modalite_pratique'];
   if (json['univers'] != null) univers = Univers.fromJson(json['univers']);
       if (json['typeActivite'] != null) typeActivite = TypeActivite.fromJson(json['typeActivite']);
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'age_min': age_min,
    'age_max': age_max,
    'clubActivite': {
      'id':clubActivite.id
    },
    'heureDebut': heureDebut,
    'heureFin': heureFin,
    'lieu': lieu,
    'prix': prix,
    'date_debut': date_debut,
    'date_fin': date_fin,
    'debut_inscription': debut_inscription,
    'fin_inscription': fin_inscription,
    'description': description,
    'nombre_participants': nombre_participants,
    'modalite_pratique': modalite_pratique,
    'univers': {
      'id':univers.id
    },
    'typeActivite': {
      'id':typeActivite.id
    },
  };
}