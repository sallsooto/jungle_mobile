import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jungle/Animation/FadeAnimation.dart';
import 'package:jungle/core/model/enfant.dart';
import 'package:jungle/core/model/jwt-token.dart';
import 'package:jungle/core/model/key-professionnel.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:jungle/core/model/professionnel.dart';
import 'package:jungle/core/model/sous-univers.dart';
import 'package:jungle/core/model/univers.dart';
import 'package:jungle/core/model/user-details.dart';
import 'package:jungle/core/service/enfant-service.dart';
import 'package:jungle/core/service/key-professionnel-service.dart';
import 'package:jungle/core/service/professionel-service.dart';
import 'package:jungle/core/service/sous-univers-service.dart';
import 'package:jungle/core/service/univers-service.dart';
import 'package:jungle/core/service/user-details-service.dart';
import 'package:jungle/core/service/user-service.dart';
import 'package:jungle/core/util/DateConverter.dart';
import 'package:jungle/core/util/MyAppColors.dart';
import 'package:jungle/ui/app-drawer.dart';
import 'package:jungle/ui/critere-recherche.dart';
import 'package:jungle/ui/login.dart';


List<SousUnivers> sousUniversG = [];
Univers universG;

class UniversDetailsPage extends StatefulWidget {
  UniversDetailsPage({@required this.univers, @required this.sousUnivers}){
    universG=this.univers;
    sousUniversG=this.sousUnivers;
  }

  final Univers univers;
  final List<SousUnivers>  sousUnivers;

  @override
  _UniversDetailsPageState createState() => _UniversDetailsPageState();
}

class _UniversDetailsPageState extends State<UniversDetailsPage> {
  String _username;
  String _password;
  Map<String, dynamic> tokenJson;
  JWTToken jwtToken;
  final storage = new FlutterSecureStorage();
  UserDetails userDetails;
  final UserDetailsService userDetailsService = new UserDetailsService();
  final _formKey = GlobalKey<FormState>();
  bool checkedValue=false;
  String dropdownValue = 'Bénéficiaire';
  var adresseCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  var nomCtrl = TextEditingController();
  var nomTuteurCtrl = TextEditingController();
  var prenomTuteurCtrl = TextEditingController();
  var emailTuteurCtrl = TextEditingController();
  var phoneTuteurCtrl = TextEditingController();
  var prenomCtrl = TextEditingController();
  var phoneCtrl = TextEditingController();
  var userIdCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  var confirmPasswordCtrl = TextEditingController();
  var dateNaissCtrl = TextEditingController();
  String dateNaissance;
  EnfantService enfantService=new EnfantService();
  ProfessionelService professionnelService = new ProfessionelService();
  bool finded;
  KeyProfessionnel _keyProfessionnelG;
  Professionnel professionnelG;
  DateTime datePickerG=DateTime.now();
  int age = 0;

  final _keyProfessionnelService = new KeyProfessionnelService();
  final _professionnelService = new ProfessionelService();
  List<KeyProfessionnel> _keyProfessionnels = [];
  List<Professionnel> _professionnels = [];
  String _searchValue;

  bool _obscurePwdText=true;
  bool _obscurePwdConfirmText=true;

  final conditionsSnackBar = SnackBar(content: Text("Vous n'avez pas accepter les conditions d'utilisation"),
      backgroundColor: Colors.red, duration: Duration(seconds: 4, milliseconds: 500));

  final insertionSnackBar = SnackBar(content: Text("Effectué avec succès, consultez votre boite mail"),
    backgroundColor: Colors.green,duration: Duration(seconds: 7, milliseconds: 500),);

  bool optInValue=false;

  @override
  void initState(){
    super.initState();
    bootstrapGridParameters(
      gutterSize: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    final double itemWidth = size.width;
    return Scaffold(
      appBar:
      AppBar(
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder:
                              (context) =>
                              LoginPage()));
                },
                child: Icon(
                  Icons.account_box,
                  size: 30.0,
                ),
              )
          ),
        ],
      ),
      drawer: AppDrawer(),
      body:
      SingleChildScrollView(
        child: BootstrapContainer(
          fluid: true,
          children: [

            Container(
              width: itemWidth,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 3, left: 7, right: 7, bottom: 7),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchValue = value;
                    });
                  },
                  decoration: InputDecoration(
                    // labelText: "Search",
                    hintText: "Rechercher un sous univers...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: MyAppColors.secondaryColor,
              ),
            ),

            BootstrapContainer(
              fluid: false,
              decoration: BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.only(top: 50),
              children: <Widget>[
                BootstrapRow(
                  height: 60,
                  children: <BootstrapCol>[
                    BootstrapCol(
                      sizes: 'col-12',
                      child: Column(
                        children: [
                          SizedBox(height: 8,),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: MyAppColors.primaryColor,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            width: 600,
                            height: 150,
                            padding: EdgeInsets.all(10),
                            child:
                            Container(
                              height: 50,
                              color: MyAppColors.secondaryColor,
                              child: Center(
                                child:
                                Column(
                                  children:[
                                    SizedBox(height: 4,),
                                    Text(
                                      universG.nom,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 30, color: Colors.white),
                                    ),
                                    Text(
                                      universG.description,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 17, color: Colors.white),
                                    ),
                                  ]
                                )
                              )
                            ),
                          ),

                          SizedBox(height: 8,)
                        ],
                      ),
                    )
                  ],
                ),
                for (var i = 0; i < sousUniversG.length; i++)
                  sousUniversWidgets()[i]
              ],
            ),
          ],
        ),
      ),
    );
  }



  sousUniversWidgets()
  {
    final children = <Widget>[];
    for (var i = 0; i < sousUniversG.length; i++) {
      children.add(new BootstrapCol(
          sizes: 'col-6',
          child: Column(
            children: [
              SizedBox(height: 8,),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: MyAppColors.primaryColor,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                width: 500,
                height: 150,
                padding: EdgeInsets.all(10),
                child:ContentWidget(
                  onTap: () =>{
                    print("ontap sur sous univers "+sousUniversG[i].nom),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder:
                                (context) =>
                                    CritereRecherchePage(sousUnivers: sousUniversG[i],
                                      univers: universG,))),
                  },
                  text: sousUniversG[i].nom,
                  color: MyAppColors.primaryColor,
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
            ],
          )


      ));
    }
    return children;

  }
}

class ContentWidget extends StatelessWidget {
  const ContentWidget({
    Key key,
    this.text,
    this.color,
    this.style,
    this.onTap
  }) : super(key: key);

  final String text;
  final Color color;
  final TextStyle style;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
          onTap: onTap,
          child:Container(
            height: 50,
            color: color,
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: style,
              ),
            ),
          ));
  }
}
