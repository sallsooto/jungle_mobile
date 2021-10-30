import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
import 'package:jungle/ui/univers-details.dart';
import './themes/color.dart';
import 'core/model/representant.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

final _universService = new UniversService();
final _sousUniversService = new SousUniversService();
const Utf8Codec utf8 = Utf8Codec();
List<Univers> _univers = [];
List<Univers> _filteredUnivers = [];
List<SousUnivers> _sousUnivers = [];
Univers universG;
List<SousUnivers> sousUniversG = [];
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jungle',
      theme: MyTheme.defaultTheme,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Accueil'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fr', ''),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,  this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
  bool _loading = true;

  final _keyProfessionnelService = new KeyProfessionnelService();
  final _professionnelService = new ProfessionelService();
  List<KeyProfessionnel> _keyProfessionnels = [];
  List<Professionnel> _professionnels = [];
  String _searchValue="";

  bool _obscurePwdText=true;
  bool _obscurePwdConfirmText=true;

  final conditionsSnackBar = SnackBar(content: Text("Vous n'avez pas accepter les conditions d'utilisation"),
      backgroundColor: Colors.red, duration: Duration(seconds: 4, milliseconds: 500));

  final insertionSnackBar = SnackBar(content: Text("Effectué avec succès, consultez votre boite mail"),
    backgroundColor: Colors.green,duration: Duration(seconds: 7, milliseconds: 500),);

  bool optInValue=false;


  final Location location = Location();
  //bool _loading = false;
  String long;
  String lat;
  LocationData _location;
  StreamSubscription<LocationData> _locationSubscription;
  String _error;
  double lg;
  double lt;


  @override
  void initState(){
    super.initState();
    _chargerUnivers();
    _chargerSousUnivers();
    bootstrapGridParameters(
      gutterSize: 30,
    );
    _getLocation();
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
                      _filterUnivers();
                    });
                  },
                  decoration: InputDecoration(
                    // labelText: "Search",
                    hintText: "Rechercher un univers...",
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
            !_loading?
            BootstrapContainer(
              fluid: false,
              decoration: BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.only(top: 50),
              children: <Widget>[

                universWidgets(_filteredUnivers),
              ],
            ):Container(
              margin: EdgeInsets.only(top: 30),
              child: Center(
                child: Text('Chargement des univers...', style: TextStyle(fontSize: 25),),
              ),
            ),
          ],
        ),
      ),
    );
  }


  //localisation


   Future<void> _getLocation() async {
    _locationSubscription = location.onLocationChanged.handleError(
        (dynamic err){
          if(err is PlatformException){
            setState(() {
              _error = err.code;
            });
          }
          _locationSubscription?.cancel();
          setState(() {
            _locationSubscription=null;
          });
        }).listen((LocationData _currentLocation) {
      setState(() {
        _location = _currentLocation;
        _loading = false;
        long = _location.latitude.toString();
        lat = _location.longitude.toString();
        lg = _location.longitude;
        lt = _location.latitude;
      });
    });
    setState(() {

    });
  }

  _chargerUnivers() async {
    await _universService.getUnivers().then((response) =>
    {
      if(response.body!=null && response.body!=""){
        setState(() {
          _univers = (jsonDecode(Utf8Decoder().convert(response.body.codeUnits)).
          map((i) => Univers.fromJson(i)).toList())
              .cast<Univers>().toList();
          _loading = false;
          print("taille des univers:"+_univers.length.toString());
          print("les noms");
        }),
      }
    });
    _filterUnivers();
  }

  _chargerSousUnivers() async {
    await _sousUniversService.getSousUnivers().then((response) =>
    {
      if(response.body!=null && response.body!=""){
        setState(() {
          _sousUnivers = (jsonDecode(Utf8Decoder().convert(response.body.codeUnits)).
          map((i) => SousUnivers.fromJson(i)).toList())
              .cast<SousUnivers>().toList();
          print("taille des sous univers:"+_sousUnivers.length.toString());
        }),
      }
    });
  }

  void _filterUnivers() {
    if (_searchValue != null && _searchValue != '') {
      print('search in ' + _searchValue);
      _searchValue = _searchValue.toLowerCase().trim();
      setState(() {
        _filteredUnivers = _univers.where((univ) =>
        univ.nom != null &&
            univ.nom.toLowerCase().contains(_searchValue)
        ).toList();
      });
    } else {
      setState(() {
        print('vide');
        _filteredUnivers = _univers;
      });
    }
  }

  Widget universWidgets(List<Univers> univers)
  {
    return new BootstrapContainer(
        fluid: false,
        decoration: BoxDecoration(color: Colors.white),
        children:
        univers.map((item) => new BootstrapRow(
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
                    child:ContentWidget(
                      onTap: () =>{
                        universG=item,
                        sousUniversG=_sousUnivers.where((i) => i.univers!=null &&
                          i.univers.id==item.id).toList(),
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder:
                      (context) =>
                          UniversDetailsPage(univers: universG, sousUnivers: sousUniversG))),
                      },
                      text: item.nom,
                      color: MyAppColors.secondaryColor,
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),

                  SizedBox(height: 8,)
                ],
              ),
            ),
            for (var i = 0; i < sousUniversWidgets(item.id).length; i++)
              sousUniversWidgets(item.id)[i]
          ],
        )).toList());
  }

  sousUniversWidgets(int universId)
  {
    List<SousUnivers> sousUnivers=[];
    _sousUnivers.forEach((element) {
      if(element.univers!=null && element.univers.id==universId && element.displayInHome)
        sousUnivers.add(element);
    });
    final children = <Widget>[];
    for (var i = 0; i < sousUnivers.length; i++) {
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
                    print("ontap sur sous univers "+sousUnivers[i].nom),
                   print(sousUnivers[i].univers.nom),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder:
                                (context) =>
                                CritereRecherchePage(sousUnivers: sousUnivers[i],
                                  univers:  sousUnivers[i].univers,))),
                  },
                  text: sousUnivers[i].nom,
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
