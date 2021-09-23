import 'package:jungle/core/model/activite.dart';
import 'package:jungle/core/model/club.dart';

class Photo {
  final int id;
  final String image;
  final String imageContentType;
  final Activite activitePhoto;
  final Club photoToClub;

  Photo(this.id, this.activitePhoto,this.image,this.imageContentType,this.photoToClub);

  Photo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        image = json['image'],
        imageContentType = json['imageContentType'],
        activitePhoto = json['activitePhoto'],
        photoToClub = json['photoToClub'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'image': image,
    'imageContentType': imageContentType,
    'activitePhoto': activitePhoto,
    'photoToClub': photoToClub,
  };
}