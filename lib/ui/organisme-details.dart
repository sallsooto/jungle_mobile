import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jungle/Animation/FadeAnimation.dart';
import 'package:jungle/core/model/activite.dart';
import 'package:jungle/core/model/club.dart';
import 'package:jungle/core/model/enfant.dart';
import 'package:jungle/core/model/jwt-token.dart';
import 'package:jungle/core/model/key-professionnel.dart';
import 'package:jungle/core/model/professionnel.dart';
import 'package:jungle/core/model/representant.dart';
import 'package:jungle/core/model/sous-univers.dart';
import 'package:jungle/core/model/univers.dart';
import 'package:jungle/core/model/user-details.dart';
import 'package:jungle/core/service/enfant-service.dart';
import 'package:jungle/core/service/key-professionnel-service.dart';
import 'package:jungle/core/service/mail-service.dart';
import 'package:jungle/core/service/professionel-service.dart';
import 'package:jungle/core/service/user-details-service.dart';
import 'package:jungle/core/util/MyAppColors.dart';
import 'package:jungle/main.dart';
import 'package:jungle/ui/list-activites.dart';
import 'package:jungle/ui/photos-organisme.dart';

Club organismeG;
final MailService mailService=new MailService();
class OrganismeDetailsPage extends StatefulWidget {
  OrganismeDetailsPage({@required this.club}){
    organismeG=this.club;
  }

  final Club club;

  @override
  _OrganismeDetailsPageState createState() => _OrganismeDetailsPageState();
}

class _OrganismeDetailsPageState extends State<OrganismeDetailsPage> {
  Map<String, dynamic> tokenJson;
  JWTToken jwtToken;
  final storage = new FlutterSecureStorage();
  UserDetails userDetails;
  final UserDetailsService userDetailsService = new UserDetailsService();
  final _formKey = GlobalKey<FormState>();
  bool checkedValue=false;
  var sousUniversCtrl = TextEditingController();
  var ageCtrl = TextEditingController();
  var universCtrl = TextEditingController();
  var typeActiviteCtrl = TextEditingController();
  var ageBeneficiaireCtrl = TextEditingController();
  var critereCtrl = TextEditingController();
  var codePostalCtrl = TextEditingController();
  var adresseCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var villeCtrl = TextEditingController();
  var telephoneCtrl = TextEditingController();

  var nomCtrl = TextEditingController();
  var organismeCtrl = TextEditingController();
  var trancheAgeCtrl = TextEditingController();
  var dateDebutCtrl = TextEditingController();
  var dateFinCtrl = TextEditingController();
  var prixCtrl = TextEditingController();
  var emailContentCtrl = TextEditingController();
  String dateNaissance;
  EnfantService enfantService=new EnfantService();
  ProfessionelService professionnelService = new ProfessionelService();
  bool finded;
  Professionnel professionnelG;
  DateTime datePickerG=DateTime.now();
  int age = 0;
  final envoiMailSnackBar = SnackBar(content: Text("Email envoyé avec succès"),
    backgroundColor: Colors.green,duration: Duration(seconds: 7, milliseconds: 500),);
  final echecEnvoiMailSnackBar = SnackBar(content: Text("Une erreur s'est produite. Email non envoyé"),
      backgroundColor: Colors.red, duration: Duration(seconds: 4, milliseconds: 500));

  @override
  void initState(){
    super.initState();
    nomCtrl.text = organismeG.nom;
    adresseCtrl.text = organismeG.adresse;
    villeCtrl.text = organismeG.ville;
    emailCtrl.text = organismeG.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        title: Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder:
                            (context) =>
                            MyHomePage())),
              },
              child: Text('Annuler',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            )
        ),

        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.account_box,
                  size: 30.0,
                ),
              )
          ),
        ],
      ) ,
      body:
      Form(
        key: _formKey,
        child:
        Scaffold(
          body:
          Center(
              child: ListView(
                children: [
                  Center(
                      child:_organismeDetails()),
                ],
              )),
        ),
      ),
    );
  }

  Widget _organismeDetails(){
    return Column(
        children: [
          FadeAnimation(0.7,
              Padding(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  controller: nomCtrl,
                  readOnly: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Nom';
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(), // add padding to adjust icon
                        child: Icon(Icons.supervised_user_circle),
                      ),
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyAppColors.primaryColor,
                        ),
                      )),
                ),
              )),

          Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              controller: adresseCtrl,
              readOnly: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Adresse';
                } else {
                  return null;
                }
              },
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(), // add padding to adjust icon
                    child: Icon(Icons.supervised_user_circle),
                  ),
                  labelText: 'Adresse',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyAppColors.primaryColor,
                    ),
                  )),
            ),
          ),

          FadeAnimation(0.7,
              Padding(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  controller: codePostalCtrl,
                  readOnly: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Code Postal';
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(), // add padding to adjust icon
                        child: Icon(Icons.email_sharp),
                      ),
                      labelText: 'Code Postal',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyAppColors.primaryColor,
                        ),
                      )),
                ),
              )),

          Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              controller: villeCtrl,
              readOnly: true,
              validator: (value) {
                if (value.isEmpty) {
                  return "Ville";
                } else {
                  return null;
                }
              },
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(), // add padding to adjust icon
                    child: Icon(Icons.supervised_user_circle),
                  ),
                  labelText: "Ville",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyAppColors.primaryColor,
                    ),
                  )),
            ),
          ),

          FadeAnimation(0.7,
              Padding(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  controller: telephoneCtrl,
                  readOnly: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Téléphone';
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(), // add padding to adjust icon
                        child: Icon(Icons.email_sharp),
                      ),
                      labelText: 'Téléphone',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyAppColors.primaryColor,
                        ),
                      )),
                ),
              )),

          FadeAnimation(0.7,
              Padding(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  onTap: () {
                    print("envoi email");
                    sendEmailToOrganismeDialog(context, "Contacter l'organisme", "Question", organismeG.email);
                  },
                  controller: emailCtrl,
                  readOnly: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Email';
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(), // add padding to adjust icon
                        child: Icon(Icons.email_sharp),
                      ),
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyAppColors.primaryColor,
                        ),
                      )),
                ),
              )),
          

          SizedBox(height: 5),
          ElevatedButton(
            style: ButtonStyle(minimumSize: MaterialStateProperty.all<Size>(Size(150,50))),
            onPressed: () {
              Navigator.push(
                  context,
              MaterialPageRoute(
                  builder:
                  (context)=>PhotoOrganisme(club: organismeG,)
              ));
            
            },
            child: Text(
                "Photos"
            ),
          ),
          SizedBox(height: 20),
        ]);
  }

  void sendEmailToOrganismeDialog(BuildContext context, String title,String objet, String email) =>
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: new Expanded(
                child: Container(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: Text(
                            title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 30,
                                color: MyAppColors.secondaryColor,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child:
                            TextFormField(
                              controller: emailContentCtrl,
                            )),
                        SizedBox(
                          width: 320.0,
                          child: ElevatedButton(
                            onPressed: () async {
                              await mailService.sendEmail(email, objet, emailContentCtrl.text).then((response) => {
                                if(response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.noContent){
                                  ScaffoldMessenger.of(context).showSnackBar(envoiMailSnackBar),
                                }
                                else
                                  ScaffoldMessenger.of(context).showSnackBar(echecEnvoiMailSnackBar),
                              });
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MyAppColors.secondaryColor),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.all(10)),
                              minimumSize: MaterialStateProperty.all<Size>(Size(350, 40)),
                            ),
                            child: Text(
                              "Envoyer",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });

  void photoClub(Club club){
  Text(club.id.toString());
  Text(club.adresse);
  }
  Widget photoOranisme(Club club){
    return Row(
      children: [
        Column(
           children: [
             Text(club.adresse),
           ],
        )
      ],
    );
  }
  
  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: new Expanded(
                child: Container(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: Text(
                            title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 30,
                                color: MyAppColors.secondaryColor,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 25),
                            )),
                        SizedBox(
                          width: 320.0,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MyAppColors.secondaryColor),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.all(10)),
                              minimumSize: MaterialStateProperty.all<Size>(Size(350, 40)),
                            ),
                            child: Text(
                              "Ok",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
}
