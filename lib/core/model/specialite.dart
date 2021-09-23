class Specialite {
  final int id;
  final String nom;

  Specialite(this.id, this.nom);

  Specialite.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nom = json['nom'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom
  };
}