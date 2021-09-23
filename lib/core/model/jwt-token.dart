class JWTToken {
  String id_token;

  JWTToken(this.id_token);

  JWTToken.fromJson(Map<String, dynamic> json) {
    id_token = json['id_token'];
  }

  Map<String, dynamic> toJson() => {'id_token': id_token};
}
