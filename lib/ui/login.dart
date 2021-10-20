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
import 'package:jungle/core/model/professionnel.dart';
import 'package:jungle/core/model/representant.dart';
import 'package:jungle/core/model/user-details.dart';
import 'package:jungle/core/service/enfant-service.dart';
import 'package:jungle/core/service/key-professionnel-service.dart';
import 'package:jungle/core/service/professionel-service.dart';
import 'package:jungle/core/service/user-details-service.dart';
import 'package:jungle/core/service/user-service.dart';
import 'package:jungle/core/util/DateConverter.dart';
import 'package:jungle/core/util/MyAppColors.dart';
import 'package:jungle/main.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key,  this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    _chargerKeyProfessionnels();
    _chargerProfessionnels();
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
          DefaultTabController(
            length: 2,
            child:
            Scaffold(
              appBar: AppBar(
                toolbarHeight:50 ,
                backgroundColor: MyAppColors.secondaryColor,
                bottom: TabBar(
                  onTap: (index) {
                    // Tab index when user select it, it start from zero
                  },

                  tabs: [
                    Tab(child: Text('Se connecter', style: TextStyle(fontSize: 20),),),
                    Tab(child: Text("S'inscrire", style: TextStyle(fontSize: 20),),),

                  ],

                ),
              ),
              body: TabBarView(
                children: [
                  _login(),
                  Center(
                      child: ListView(
                        children: [
                          Center(
                            child:DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.keyboard_arrow_up),
                              iconSize: 24,
                              elevation: 16,

                              style:  TextStyle(color: MyAppColors.primaryColor,fontSize: 25),
                              underline: Container(
                                height: 2,
                                color: MyAppColors.secondaryColor,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  _chargerKeyProfessionnels();
                                  _chargerProfessionnels();
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>['Bénéficiaire', 'Représentant']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),),
                          (dropdownValue.compareTo('Bénéficiaire')==0)?
                          _inscriptionEnfant():
                          _inscriptionRepresentant(),

                        ],
                      )),
                ],
              ),
            ),
          ),
        )
    );
  }

  Widget _login(){
    return Center(
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            FadeAnimation(0.7,
                Padding(
                  padding: EdgeInsets.all(15),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Courriel';
                      } else {
                        _username=value;
                        print(_username);
                        return null;
                      }
                    },
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(), // add padding to adjust icon
                          child: Icon(Icons.email_sharp),
                        ),
                        labelText: 'Courriel',
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
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Mot de passe';
                  }
                  /*else if (!isValidPassword(value)){
                    return 'Au moins 8 caractères MAJ,minis,Caract. Spécial';
                  }*/
                  else {
                    _password=value;
                    return null;
                  }
                },
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                obscureText: _obscurePwdText,
                decoration: InputDecoration(
                    prefixIcon: Padding(
                        padding: EdgeInsets.only(), // add padding to adjust icon
                        child: IconButton(
                          color: Colors.black45,
                          icon: Icon(Icons.lock),
                          onPressed: _togglePwd,
                        )
                    ),
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: MyAppColors.primaryColor,
                      ),
                    )),
              ),
            ),
            SizedBox(height: 30,),
            Center(
              child: FadeAnimation(1.0, Text("Mot de passe Oublié", style:
              TextStyle(fontSize: 15,fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline, fontStyle: FontStyle.italic),)),
            ),
            SizedBox(height: 30,),
            FadeAnimation(1.3,CheckboxListTile(
              title: Text("Rester connecté", style: TextStyle(fontSize: 25,
              ),),
              value: checkedValue,
              onChanged: (newValue) {
                setState(() {
                  checkedValue = newValue;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
            ),),
            SizedBox(height: 30,),
            FadeAnimation(2,
                ElevatedButton(
                    child: Text('Je me connecte'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        print(_username);
                        UserService.authenticate(
                            _username.trim(), _password)
                            .then((response) =>
                        {
                          print(response.statusCode),
                          if (response.statusCode == HttpStatus.ok)
                            {
                              tokenJson = json.decode(response.body),
                              jwtToken = JWTToken.fromJson(tokenJson),
                              // saving token
                              storage.write(
                                  key: 'token', value: jwtToken.id_token),
                              // finding user infromation details
                              userDetailsService
                                  .getAndstoreUserDetails()
                                  .then((value) =>
                              {
                                userDetailsService
                                    .getStoredUserDetails()
                                    .then((value) =>
                                {
                                  setState(() {
                                    userDetails = value;
                                    if (userDetails !=
                                        null &&
                                        userDetails
                                            .activated) {
                                      storage
                                          .read(
                                          key:
                                          'userDetails')
                                          .then((value) =>
                                          print(value));
                                      userDetails
                                          .getRoles()
                                          .forEach((element) =>
                                          print(
                                              element));
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                  MyHomePage()));

                                    } else {
                                      displayDialog(
                                          context,
                                          'Erreur',
                                          'Compte inactif !');
                                    }
                                  }),
                                }),
                              }),
                            }
                          else
                            {
                              if (response.statusCode ==
                                  HttpStatus.unauthorized)
                                {
                                  displayDialog(context, 'Erreur',
                                      'Identifiants invalides !'),
                                }
                              else
                                {
                                  displayDialog(
                                      context,
                                      'Erreur ' +
                                          response.statusCode.toString(),
                                      'Connexion echouée!'),
                                }
                            }
                        })
                            .catchError((e) =>
                        {
                          print(e),
                          displayDialog(
                              context, 'Erreur', 'Echec de la connexion'),
                        });
                      }
                    }
                )),
          ],
        ));
  }

  Widget _inscriptionEnfant(){
    return Column(
        children: [
          FadeAnimation(0.7,
              Padding(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  controller: prenomCtrl,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Prénom';
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
                      labelText: 'Prénom',
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
              controller: nomCtrl,
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
          ),

          FadeAnimation(0.7,
              Padding(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  controller: dateNaissCtrl,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Champ obligatoire';
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  onTap: (){
                    selectDate(context);
                  },
                  readOnly: true,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.event_note),
                    hintText: "Date Naissance",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: MyAppColors.secondaryColor,
                      ),
                    ),
                    //fillColor: Colors.green
                  ),
                  /* onChanged: (value) {
                _formFieldChangedHandler();
              }, */
                ),
              )),
          FadeAnimation(0.7,
              Padding(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  controller: emailCtrl,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Courriel';
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
                      labelText: 'Courriel',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MyAppColors.primaryColor,
                        ),
                      )),
                ),
              )),
          age<18?Column(
              children:[
                FadeAnimation(0.7,
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        controller: prenomTuteurCtrl,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Prénom Tuteur';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(), // add padding to adjust icon
                              child: Icon(Icons.supervised_user_circle_outlined),
                            ),
                            labelText: 'Prénom Tuteur',
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
                        controller: nomTuteurCtrl,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Nom Tuteur';
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
                            labelText: 'Nom Tuteur',
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
                        controller: phoneTuteurCtrl,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Téléphone Tuteur';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(), // add padding to adjust icon
                              child: Icon(Icons.phone),
                            ),
                            labelText: 'Téléphone Tuteur',
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
                        controller: emailTuteurCtrl,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Courriel Tuteur obligatoire';
                          }
                          else if(value.compareTo(emailCtrl.text)==0){
                            return 'les courriels ne doivent pas être identiques';
                          }
                          else {
                            return null;
                          }
                        },
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(), // add padding to adjust icon
                              child: Icon(Icons.email_sharp),
                            ),
                            labelText: 'Courriel Tuteur',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: MyAppColors.primaryColor,
                              ),
                            )),
                      ),
                    )),
              ]
          ):Text('')
          ,

          Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              controller: passwordCtrl,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Mot de passe';
                }
                else if (!isValidPassword(value)){
                  return 'Au moins 8 caractères MAJ,minis,Caract. Spécial';
                }
                else {
                  _password=value;
                  return null;
                }
              },
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              obscureText: _obscurePwdText,
              decoration: InputDecoration(
                  prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: IconButton(
                        color: Colors.black45,
                        icon: Icon(Icons.lock),
                        onPressed: _togglePwd,
                      )
                  ),
                  labelText: 'Mot de passe',
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
              validator: (value) {
                if (value.isEmpty) {
                  return 'Champ obligatoire';
                }
                else if(value.compareTo(passwordCtrl.text)!=0){
                  return 'Mots de passe non conformes';
                }
                else {
                  return null;
                }
              },
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              obscureText: _obscurePwdConfirmText,
              decoration: InputDecoration(
                  prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: IconButton(
                        color: Colors.black45,
                        icon: Icon(Icons.lock),
                        onPressed: _toggleConfirmPwd,
                      )
                  ),
                  labelText: 'Confirmer le mot de passe',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyAppColors.primaryColor,
                    ),
                  )),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(0),
              child: CheckboxListTile(
                title: Text("OptIn CGU",style: TextStyle(fontWeight: FontWeight.bold),),
                value: optInValue,
                onChanged: (newValue) {
                  setState(() {
                    optInValue = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              )
          ),
          SizedBox(height: 5),
          ElevatedButton(
            style: ButtonStyle(minimumSize: MaterialStateProperty.all<Size>(Size(150,50))),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                if (!optInValue){
                  ScaffoldMessenger.of(context).showSnackBar(conditionsSnackBar);
                }

                else {
                  enfantService.createEnfant(new Enfant(nom: nomCtrl.text,
                    adresse: adresseCtrl.text,
                    email: emailCtrl.text,
                    prenom: prenomCtrl.text,
                    email_tuteur: emailTuteurCtrl.text,
                    dateNaissance: dateNaissCtrl.text,
                    telephone: phoneCtrl.text,
                    nom_tuteur: nomTuteurCtrl.text,
                    prenom_tuteur: prenomTuteurCtrl.text,
                    telephone_tuteur: phoneTuteurCtrl.text
                    ,), emailCtrl.text, passwordCtrl.text).then((value) =>
                  {
                    _formKey.currentState.reset(),
                    ScaffoldMessenger.of(context).showSnackBar(insertionSnackBar),
                  });
                }
              }
            },
            child: Text(
                "Valider"
            ),
          ),
          SizedBox(height: 20),
        ]);
  }

  Widget _inscriptionRepresentant(){
    return Column(
        children: [
          FadeAnimation(0.7,
              Padding(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  controller: prenomCtrl,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Prénom';
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
                      labelText: 'Prénom',
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
              controller: nomCtrl,
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
          ),
          FadeAnimation(0.7,
              Padding(
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  controller: emailCtrl,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Courriel';
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
                      labelText: 'Courriel',
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
              controller: passwordCtrl,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Mot de passe';
                }
                else if (!isValidPassword(value)){
                  return 'Au moins 8 caractères MAJ,minis,Caract. Spécial';
                }
                else {
                  _password=value;
                  return null;
                }
              },
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              obscureText: _obscurePwdText,
              decoration: InputDecoration(
                  prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: IconButton(
                        color: Colors.black45,
                        icon: Icon(Icons.lock),
                        onPressed: _togglePwd,
                      )
                  ),
                  labelText: 'Mot de passe',
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
              validator: (value) {
                if (value.isEmpty) {
                  return 'Champ obligatoire';
                }
                else if(value.compareTo(passwordCtrl.text)!=0){
                  return 'Mots de passe non conformes';
                }
                else {
                  return null;
                }
              },
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              obscureText: _obscurePwdConfirmText,
              decoration: InputDecoration(
                  prefixIcon: Padding(
                      padding: EdgeInsets.only(), // add padding to adjust icon
                      child: IconButton(
                        color: Colors.black45,
                        icon: Icon(Icons.lock),
                        onPressed: _toggleConfirmPwd,
                      )
                  ),
                  labelText: 'Confirmer le mot de passe',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyAppColors.primaryColor,
                    ),
                  )),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(0),
              child: CheckboxListTile(
                title: Text("OptIn CGU",style: TextStyle(fontWeight: FontWeight.bold),),
                value: optInValue,
                onChanged: (newValue) {
                  setState(() {
                    optInValue = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              )
          ),
          SizedBox(height: 5),
          ElevatedButton(
            style: ButtonStyle(minimumSize: MaterialStateProperty.all<Size>(Size(150,50))),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                if (!optInValue)
                  ScaffoldMessenger.of(context).showSnackBar(conditionsSnackBar);
                else {
                  enfantService.createRepresentant(new Representant(nom: nomCtrl.text,
                      email: emailCtrl.text,
                      prenom: prenomCtrl.text,
                      telephone: phoneCtrl.text), passwordCtrl.text).then((value) =>
                  {
                    _formKey.currentState.reset(),
                    ScaffoldMessenger.of(context).showSnackBar(insertionSnackBar),
                  });
                }

              }
            },
            child: Text(
                "Je crée mon compte"
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

  _chargerKeyProfessionnels() async {
    await _keyProfessionnelService.getKeyProfessionnels().then((response) =>
    {
      if(response.body!=null && response.body!=""){
        setState(() {
          _keyProfessionnels = (jsonDecode(response.body).
          map((i) => KeyProfessionnel.fromJson(i)).toList())
              .cast<KeyProfessionnel>().toList();
          print("taille des pvs:"+_keyProfessionnels.length.toString());
        }),
      }
    });
  }

  _chargerProfessionnels() async {
    await _professionnelService.getProfessionnels().then((response) =>
    {
      if(response.body!=null && response.body!=""){
        setState(() {
          _professionnels = (jsonDecode(response.body).
          map((i) => Professionnel.fromJson(i)).toList())
              .cast<Professionnel>().toList();
          print("taille des professionnels:"+_professionnels.length.toString());
        }),
      }
    });
  }

  void _chercherKeyProfessionnel(){
    if(_searchValue != null && _searchValue != '') {
      _searchValue = _searchValue.toLowerCase().trim();
      setState(() {
        finded=false;
        _keyProfessionnels.forEach((element) {
          print(element.cle);
          if(element.cle.toString().compareTo(_searchValue)==0 && element.valid==true){
            print('recherche');
            _keyProfessionnelG=element;
            _professionnels.forEach((prof) {
              if(prof.id==_keyProfessionnelG.professionel_id)
                professionnelG=prof;
              nomCtrl.text=prof.nom;
              prenomCtrl.text=prof.prenom;
              emailCtrl.text=prof.email;
            });
            print("la clé trouvée:"+_keyProfessionnelG.cle.toString());
            finded=true;

          }
          if(!finded){
            _keyProfessionnelG=null;
          }
        });
      });
    }else{
      setState(() {
        _keyProfessionnelG=null;
      });
    }
  }

  // Toggles the password show status
  void _togglePwd() {
    print('dans le toggle');
    print(_obscurePwdText);
    setState(() {
      _obscurePwdText = !_obscurePwdText;
    });
  }

  //verification du mot de passe
  bool isValidPassword(String password){
    RegExp regExp = new RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}",
      multiLine: false,
    );
    return regExp.hasMatch(password);
  }

  selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      helpText: 'Date de naissance',
      cancelText: 'Annuler',
      confirmText: 'Valider',
      errorFormatText: 'Format invalide',
      errorInvalidText: 'Date Invalide',
      fieldLabelText: 'Date de naissance',
      fieldHintText: 'Mois/Jour/Année',
      context: context,
      initialDate: datePickerG,
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      builder: (context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: MyAppColors.secondaryColor,
              )
          ),
          child: child,
        );
      },
    );
    if(picked!=null && picked!=datePickerG)
      setState(() {
        datePickerG=picked;
        dateNaissCtrl.text=DateConverter.dateToString(datePickerG);
        age=DateTime.now().year-datePickerG.year;
      });
  }

  void _toggleConfirmPwd() {
    setState(() {
      _obscurePwdConfirmText = !_obscurePwdConfirmText;
    });
  }

}
