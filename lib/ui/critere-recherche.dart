import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jungle/Animation/FadeAnimation.dart';
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
import 'package:jungle/core/service/professionel-service.dart';
import 'package:jungle/core/service/user-details-service.dart';
import 'package:jungle/core/util/MyAppColors.dart';
import 'package:jungle/main.dart';
import 'package:jungle/ui/list-activites.dart';

SousUnivers sousUniversG;
Univers universG;
class CritereRecherchePage extends StatefulWidget {
  CritereRecherchePage({@required this.univers, @required this.sousUnivers}){
    universG=this.univers;
    sousUniversG=this.sousUnivers;
  }

  final Univers univers;
  final SousUnivers sousUnivers;

  @override
  _CritereRecherchePageState createState() => _CritereRecherchePageState();
}

class _CritereRecherchePageState extends State<CritereRecherchePage> {
  String _username;
  String _password;
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
    universCtrl.text = universG.nom;
    sousUniversCtrl.text = sousUniversG.nom;
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
                            child:_critereRecherche()),
                        ],
                      )),
            ),
          ),
        );
  }

  Widget _critereRecherche(){
    return Column(
        children: [
          FadeAnimation(0.7,
              Padding(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  controller: universCtrl,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Univers';
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
                      labelText: 'Univers',
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
              controller: sousUniversCtrl,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Sous Univers';
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
                  labelText: 'Sous Univers',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyAppColors.primaryColor,
                    ),
                  )),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              controller: codePostalCtrl,
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
                    child: Icon(Icons.supervised_user_circle),
                  ),
                  labelText: 'Code postal',
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

          FadeAnimation(0.7,
              Padding(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  controller: ageCtrl,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Age';
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
                      labelText: 'Age',
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
                  controller: critereCtrl,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Critère de recherche';
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
                      labelText: 'Critère de recherche',
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
                          (context) =>
                              ListActivitesPage(univers: universG,)));
              },
            child: Text(
                "Rechercher"
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
}
