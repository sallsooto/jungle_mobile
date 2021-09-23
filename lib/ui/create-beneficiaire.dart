import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jungle/Animation/FadeAnimation.dart';
import 'package:jungle/core/model/enfant.dart';
import 'package:jungle/core/model/jwt-token.dart';
import 'package:jungle/core/model/representant.dart';
import 'package:jungle/core/model/user-details.dart';
import 'package:jungle/core/service/enfant-service.dart';
import 'package:jungle/core/service/user-details-service.dart';
import 'package:jungle/core/util/DateConverter.dart';
import 'package:jungle/core/util/MyAppColors.dart';
import 'package:jungle/main.dart';

Representant representantG;
class CreateBeneciairePage extends StatefulWidget {
  CreateBeneciairePage({@required this.representant}){
    representantG=this.representant;
  }

  final Representant representant;

  @override
  _CreateBeneciairePageState createState() => _CreateBeneciairePageState();
}

class _CreateBeneciairePageState extends State<CreateBeneciairePage> {
  Map<String, dynamic> tokenJson;
  JWTToken jwtToken;
  final storage = new FlutterSecureStorage();
  UserDetails userDetails;
  final UserDetailsService userDetailsService = new UserDetailsService();
  final _formKey = GlobalKey<FormState>();

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
  EnfantService enfantService=new EnfantService();
  final insertionSnackBar = SnackBar(content: Text("Effectué avec succès"),
    backgroundColor: Colors.green,duration: Duration(seconds: 7, milliseconds: 500),);

  String dateNaissance;
  int age = 0;
  DateTime datePickerG=DateTime.now();
  @override
  void initState(){
    super.initState();
    nomTuteurCtrl.text = representantG.nom;
    prenomTuteurCtrl.text = representantG.prenom;
    emailTuteurCtrl.text = representantG.email;
    phoneTuteurCtrl.text = representantG.telephone;
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
                      child:_inscriptionEnfant()),
                ],
              )),
        ),
      ),
    );
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
          ):Text(''),

          SizedBox(height: 5),
          ElevatedButton(
            style: ButtonStyle(minimumSize: MaterialStateProperty.all<Size>(Size(150,50))),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                  enfantService.createEnfantByRepresentant(new Enfant(nom: nomCtrl.text,
                    adresse: adresseCtrl.text,
                    email: emailCtrl.text,
                    prenom: prenomCtrl.text,
                    email_tuteur: emailTuteurCtrl.text,
                    dateNaissance: dateNaissCtrl.text,
                    telephone: phoneCtrl.text,
                    nom_tuteur: nomTuteurCtrl.text,
                    prenom_tuteur: prenomTuteurCtrl.text,
                    representant: representantG,
                    telephone_tuteur: phoneTuteurCtrl.text
                    ,), representantG.id).then((value) =>
                  {
                    _formKey.currentState.reset(),
                    ScaffoldMessenger.of(context).showSnackBar(insertionSnackBar),
                  });

              }
            },
            child: Text(
                "Valider"
            ),
          ),
          SizedBox(height: 20),
        ]);
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


}
