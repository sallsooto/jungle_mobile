import 'package:jungle/core/util/DateConverter.dart';

class UserDetails{
  int id;
  String login;
  String firstName;
  String lastName;
  String email;
  String imageUrl;
  bool activated;
  String langKey;
  String createdBy;
  DateTime createdDate;
  String lastModifiedBy;
  DateTime lastModifiedDate;

  List<dynamic> authorities;
  UserDetails({
    this.id, this.login, this.firstName, this.lastName,
    this.email, this.imageUrl, this.activated, this.langKey, this.createdBy,
    String createdDate,this.lastModifiedBy, String lastModifiedDate, this.authorities
  }){
    this.createdDate = DateConverter.stringToDate(createdDate);
    this.lastModifiedDate = DateConverter.stringToDate(lastModifiedDate);
  }
  UserDetails.fromJson(Map<String, dynamic> json){
    id = json['id'];
    login = json['login'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    imageUrl = json['imageUrl'];
    activated = json['activated'];
    langKey = json['langKey'];
    createdBy = json['createdBy'];
    createdDate = DateConverter.stringToDate(json['createdDate']);
    lastModifiedBy = json['lastModifiedBy'];
    lastModifiedDate = DateConverter.stringToDate(json['lastModifiedDate']);
    authorities = json['authorities'];
  }

  List<String> getRoles(){
    if(this.authorities != null && this.authorities.length > 0)
      return this.authorities.map((role) => role.toString()).toList();
    return [];
  }
}