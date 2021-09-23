class KeyProfessionnel {
  int id;
  int cle;
  int professionel_id;
  bool valid;

  KeyProfessionnel({this.id, this.cle,this.professionel_id,this.valid});

  KeyProfessionnel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        cle = json['cle'],
        professionel_id = json['professionel_id'],
        valid = json['valid'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'cle': cle,
    'professionel_id': professionel_id,
    'valid': valid
  };
}