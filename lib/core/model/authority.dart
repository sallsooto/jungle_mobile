class Authority {
  final int id;
  final String name;

  Authority(this.id, this.name);

  Authority.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name
  };
}