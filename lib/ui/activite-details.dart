import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jungle/Animation/FadeAnimation.dart';
import 'package:jungle/core/model/activite.dart';
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
import 'package:jungle/core/service/professionel-service.dart';
import 'package:jungle/core/service/user-details-service.dart';
import 'package:jungle/core/util/MyAppColors.dart';
import 'package:jungle/main.dart';
import 'package:jungle/ui/inscription.dart';
import 'package:jungle/ui/list-activites.dart';
import 'package:jungle/ui/login.dart';
import 'package:jungle/ui/organisme-details.dart';

Activite activiteG;

class ActiviteDetailsPage extends StatefulWidget {
  ActiviteDetailsPage({@required this.activite}){
    activiteG=this.activite;
  }

  final Activite activite;

  @override
  _ActiviteDetailsPageState createState() => _ActiviteDetailsPageState();
}

class _ActiviteDetailsPageState extends State<ActiviteDetailsPage> {
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

  var nomCtrl = TextEditingController();
  var organismeCtrl = TextEditingController();
  var trancheAgeCtrl = TextEditingController();
  var dateDebutCtrl = TextEditingController();
  var dateFinCtrl = TextEditingController();
  var prixCtrl = TextEditingController();
  var debutInscriptionCtrl = TextEditingController();
  var finInscriptionCtrl = TextEditingController();
  int _representUserIdG=0;

  String dateNaissance;
  EnfantService enfantService=new EnfantService();
  ProfessionelService professionnelService = new ProfessionelService();
  bool finded;
  Professionnel professionnelG;
  DateTime datePickerG=DateTime.now();
  int age = 0;

  @override
  void initState(){
    super.initState();
    _getRepresentantUserIdIfConnected();
    nomCtrl.text = activiteG.nom;
    organismeCtrl.text = activiteG.clubActivite!=null?activiteG.clubActivite.nom:
                                                      "";
    dateDebutCtrl.text = activiteG.date_debut;
    dateFinCtrl.text = activiteG.date_fin;
    prixCtrl.text = activiteG.prix.toString();
    debutInscriptionCtrl.text= activiteG.debut_inscription;
    finInscriptionCtrl.text= activiteG.fin_inscription;

    typeActiviteCtrl.text = activiteG.typeActivite!=null?activiteG.typeActivite.nom:
    "";
    trancheAgeCtrl.text = activiteG.age_min.toString()+ ' - ' + activiteG.age_max.toString();

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
                      child:_activiteDetails()),
                ],
              )),
        ),
      ),
    );
  }

  Widget _activiteDetails(){
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
              onTap: ()=>{
                activiteG.clubActivite!=null?
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder:
                            (context) =>
                                OrganismeDetailsPage(club: activiteG.clubActivite))):""
              },
              controller: organismeCtrl,
              readOnly: true,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(), // add padding to adjust icon
                    child: Icon(Icons.supervised_user_circle),
                  ),
                  labelText: 'Organisme',
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
                  controller: typeActiviteCtrl,
                  readOnly: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Type Activité';
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
                      labelText: 'Type Activité',
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
              controller: trancheAgeCtrl,
              readOnly: true,
              validator: (value) {
                if (value.isEmpty) {
                  return "Tranche d'age";
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
                  labelText: "Tranche d'age",
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
                  controller: critereCtrl,
                  readOnly: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Critère spécifique';
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
                      labelText: 'Critère spécifique',
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
                  controller: dateDebutCtrl,
                  readOnly: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Date début';
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
                      labelText: 'Date debut',
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
                  controller: dateFinCtrl,
                  readOnly: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Date fin';
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
                      labelText: 'Date fin',
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
                  controller: debutInscriptionCtrl,
                  readOnly: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Date début inscription';
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
                      labelText: 'Date début inscription',
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
                  controller: finInscriptionCtrl,
                  readOnly: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Date fin inscription";
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
                      labelText: 'Date fin inscription',
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
                  controller: prixCtrl,
                  readOnly: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Prix';
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
                      labelText: 'Prix',
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
              _representUserIdG!=0?
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder:
                          (context) =>
                              CreateInscriptionPage(enfant: null, activite: activiteG))):
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder:
                          (context) =>
                              LoginPage()));
            },
            child: Text(
                "Demander l'inscription"
            ),
          ),
          SizedBox(height: 20),
        ]);
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
  _getRepresentantUserIdIfConnected() async {
    await userDetailsService
        .getStoredUserDetails()
        .then((value) =>
    {

      if (value !=
          null &&
    (value.getRoles().contains("ROLE_REPRESENTANT") || value.getRoles().contains("ROLE_ENFANT"))) {

        setState(() {
          _representUserIdG = value.id;
        }),
        print("l'id du representant" + _representUserIdG.toString())
      },
      print("l'id du representant" + _representUserIdG.toString())

    });


  }
}
