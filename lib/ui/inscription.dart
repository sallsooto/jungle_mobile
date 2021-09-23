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
import 'package:jungle/core/model/inscription.dart';
import 'package:jungle/core/model/jwt-token.dart';
import 'package:jungle/core/model/user-details.dart';
import 'package:jungle/core/service/enfant-service.dart';
import 'package:jungle/core/service/inscription-service.dart';
import 'package:jungle/core/service/user-details-service.dart';
import 'package:jungle/core/util/DateConverter.dart';
import 'package:jungle/core/util/MyAppColors.dart';
import 'package:jungle/main.dart';
import 'package:select_form_field/select_form_field.dart';

Enfant enfantG;
Activite activiteG;
class CreateInscriptionPage extends StatefulWidget {
  CreateInscriptionPage({@required this.enfant, @required this.activite}){
    enfantG=this.enfant;
    activiteG = this.activite;
  }

  final Enfant enfant;
  final Activite activite;

  @override
  _CreateInscriptionPageState createState() => _CreateInscriptionPageState();
}

class _CreateInscriptionPageState extends State<CreateInscriptionPage> {
  Map<String, dynamic> tokenJson;
  JWTToken jwtToken;
  final storage = new FlutterSecureStorage();
  UserDetails userDetails;
  final UserDetailsService userDetailsService = new UserDetailsService();
  final _formKey = GlobalKey<FormState>();
  Enfant _beneficiaireG=new Enfant();
  var nomEnfantCtrl = TextEditingController();
  var nomActiviteCtrl = TextEditingController();
  var statusCtrl = TextEditingController();
  var beneficiaireCtrl = TextEditingController();
  var dateActiviteCtrl = TextEditingController();
  InscriptionService inscriptionService=new InscriptionService();
  final insertionSnackBar = SnackBar(content: Text("Effectué avec succès"),
    backgroundColor: Colors.green,duration: Duration(seconds: 7, milliseconds: 500),);

  final _enfantService = new EnfantService();

  List<Enfant> _enfants = [],
  _filteredEnfants = [];

  final List<Map<String, dynamic>> _items=[];

  bool _loading = true,
      _noEnfantfounded = true;
  int _representUserIdG=0;

  String dateNaissance;
  int age = 0;
  DateTime datePickerG=DateTime.now();
  @override
  void initState(){
    super.initState();
    nomActiviteCtrl.text = activiteG.nom;
    //nomEnfantCtrl.text = enfantG.nom;
    dateActiviteCtrl.text = activiteG.date_debut;
    _getRepresentantUserIdIfConnected();
    _fetchEnfants();
  }


  _fetchEnfantG() {
    setState(() {
      enfantG=_filteredEnfants.where((element) => element.id.toString()==beneficiaireCtrl.text).toList()[0];
    });
  }
  _fetchEnfants() async {
    print("le representant id "+_representUserIdG.toString());
    await _enfantService.getEnfantsByRepresentant(_representUserIdG).then((response) =>
    {
      if(response.statusCode == HttpStatus.ok){
        setState(() {
          _enfants = (jsonDecode(Utf8Decoder().convert(response.body.codeUnits)).
          map((i) => Enfant.fromJson(i)).toList())
              .cast<Enfant>().toList();
          _filteredEnfants = _enfants;
          _loading = false;
          if (_filteredEnfants.isNotEmpty){
            _noEnfantfounded = false;
            _filteredEnfants.forEach((enfant) { 
              _items.add(
                  {
                    'value': enfant.id,
                    'label': enfant.nom + " "+ enfant.prenom,
                    'icon': Icon(Icons.person_add),
                  }
              );
            });
          }
          else
            _noEnfantfounded = true;
        }),
      }
    });
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
                child: SelectFormField(
                  type: SelectFormFieldType.dropdown,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  icon: Icon(Icons.person),
                  labelText: 'Bénéficiaire',
                  items: _items,
                  controller: beneficiaireCtrl,
                  onFieldSubmitted: (val) => print("haaaaaaa"),
                  onChanged: (val) => {
                  setState(() {
                    print(val);
                  }),
                  },
                  onSaved: (val) => print("holla"),
                ),
              )),

          Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              controller: nomActiviteCtrl,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Activité';
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
                  labelText: 'Activite',
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
                  controller: dateActiviteCtrl,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Champ obligatoire';
                    } else {
                      return null;
                    }
                  },
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  readOnly: true,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.event_note),
                    hintText: "Date Activité",
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
          SizedBox(height: 5),
          ElevatedButton(
            style: ButtonStyle(minimumSize: MaterialStateProperty.all<Size>(Size(150,50))),
            onPressed: () async {
              _fetchEnfantG();
              if (_formKey.currentState.validate()) {
                await inscriptionService.createInscription(new Inscription(
                  activite: activiteG,
                  dateInscription: DateConverter.dateToString(DateTime.now()),
                  enfant:enfantG,
                  status: false
                )).then((value) =>
                {
                  print(value.body),
                  _formKey.currentState.reset(),
                  ScaffoldMessenger.of(context).showSnackBar(insertionSnackBar),
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder:
                  //             (context) =>
                  //             MyHomePage()))
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
