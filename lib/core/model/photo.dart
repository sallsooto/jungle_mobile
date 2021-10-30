import 'package:jungle/core/model/activite.dart';
import 'package:jungle/core/model/club.dart';

class Photo {
  int id;
  String image;
  String imageContentType;
  Activite activitePhoto;
  Club photoToClub;

  Photo(this.id, this.activitePhoto,this.image,this.imageContentType,this.photoToClub);

  Photo.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    image = json['image'];
    imageContentType = json['imageContentType'];
    /*activitePhoto = json['activitePhoto'];
    photoToClub = json['photoToClub'];*/
    if(json['activitePhoto']!=null) activitePhoto = Activite.fromJson(json['activitePhoto']);
    if(json['photoToClub']!=null) photoToClub = Club.fromJson(json['photoToClub']);
  }


  // if (json['univers'] != null) univers = Univers.fromJson(json['univers']);


  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'imageContentType': imageContentType,
    'activitePhoto': {
      'id':activitePhoto.id
    },
    'photoToClub': {
      'id':photoToClub.id
    },
  };
}