class TypeActivite {
  final int id;
  final String nom;

  TypeActivite(this.id, this.nom);

  TypeActivite.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nom = json['nom'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
  };
}