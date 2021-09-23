class Club {
   int id;
   String nom;
   String ville;
   String adresse;
   String latitude;
   String longitude;
   String ageMax;
   String ageMin;
   String email;

  Club(this.id, this.nom,this.ville,this.adresse,
        this.ageMax,this.ageMin,this.latitude,this.longitude, this.email);

  Club.fromJson(Map<String, dynamic> json){
    id = json['id'];
    nom = json['nom'];
    ville = json['ville'];
    adresse = json['adresse'];
    //ageMax = json['ageMax'],
    //ageMin = json['ageMin'],
    //latitude = json['latitude'];
    //longitude = json['longitude'];
    email = json['email'];
  }


  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'ville': ville,
    'adresse': adresse,
    'ageMax': ageMax,
    'ageMin': ageMin,
    'latitude': latitude,
    'longitude': longitude,
    'email': email
  };
}