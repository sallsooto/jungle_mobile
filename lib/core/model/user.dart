import 'package:jungle/core/model/role.dart';

class User {
   int id;
   String lastName;
   String firstName;
   String login;
   List<dynamic> authorities;
   bool activated;
   String email;
   String password;
   String langKey;



  User({this.id, this.lastName,this.firstName,this.login,this.authorities
        ,this.activated,this.email, this.password, this.langKey});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lastName = json['lastName'],
        firstName = json['firstName'],
        login = json['login'],
        authorities = json['authorities'],
        activated = json['activated'],
        email = json['email'],
        password = json['password'],
        langKey = json['langKey'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'lastName': lastName,
    'firstName': firstName,
    'login': login,
    'authorities': authorities,
    'activated': activated,
    'email': email,
    'password': password,
    'langKey': langKey,
  };
}