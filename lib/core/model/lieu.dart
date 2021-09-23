class Lieu {
  final int id;
  final String nom;
  final int latitude;
  final int longitude;
  final String adresse;

  Lieu(this.id, this.nom,this.longitude,this.latitude,this.adresse);

  Lieu.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nom = json['nom'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        adresse = json['adresse'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'latitude': latitude,
    'longitude': longitude,
    'adresse': adresse
  };
}