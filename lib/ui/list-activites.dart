import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jungle/core/model/activite.dart';
import 'package:jungle/core/model/club.dart';
import 'package:jungle/core/model/sous-univers.dart';
import 'package:jungle/core/model/type-activite.dart';
import 'package:jungle/core/model/univers.dart';
import 'package:jungle/core/service/activite-service.dart';
import 'package:jungle/core/util/MyAppColors.dart';
import 'package:jungle/main.dart';
import 'package:jungle/ui/activite-details.dart';

import 'app-drawer.dart';

Univers universG;
Club clubG;
TypeActivite typeActiviteG;
class ListActivitesPage extends StatefulWidget {
  final Univers univers;
  final Club club;
  final TypeActivite typeActivite;
  ListActivitesPage({@required this.univers, @required this.club, @required this.typeActivite}){
    universG=this.univers;
    clubG = this.club;
    typeActiviteG= this.typeActivite;
  }
  @override
  _ListActivitesPageState createState() => _ListActivitesPageState();
}

class _ListActivitesPageState extends State<ListActivitesPage> {
  final _activiteService = new ActiviteService();
  List<Activite> _activites = [],
      _filteredActivites = [],
      _selectedActivites = [];
  String _searchValue;
  List<int> _checkedIds = [];
  bool _loading = true,
      _noActivitefounded = true;

  @override
  void initState() {
    super.initState();
    _fetchActivites();
  }

  _fetchActivites() async {
    await _activiteService.getActivites().then((response) =>
    {
      if(response.statusCode == HttpStatus.ok){
        setState(() {
          _activites = (jsonDecode(Utf8Decoder().convert(response.body.codeUnits)).
          map((i) => Activite.fromJson(i)).toList())
              .cast<Activite>().toList();
          _filteredActivites = _activites.where((element) => element.univers.id==universG.id).toList();
          _loading = false;
          if (_filteredActivites.isNotEmpty)
            _noActivitefounded = false;
          else
            _noActivitefounded = true;
          _checkedIds.clear();
        }),
      }
    });
  }

  void _filterActivites() {
    if (_searchValue != null && _searchValue != '') {
      print('search in ' + _searchValue);
      _searchValue = _searchValue.toLowerCase().trim();
      setState(() {
        _filteredActivites = _activites.where((activite) =>
        activite.nom != null &&
            activite.nom.toLowerCase().contains(_searchValue)
        ).toList();
      });
    } else {
      setState(() {
        _filteredActivites = _activites;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Center(
        child: _createBody(),
      ),
      //floatingActionButton: _createFloatingActionButon(),
    );
  } // build

  Widget _createBody() {
    if (_loading) {
      return Container(
        margin: EdgeInsets.only(top: 30),
        child: Center(
          child: Text('chargement des activités...', style: TextStyle(fontSize: 25),),
        ),
      );
    } else {
      if (_noActivitefounded) {
        return Container(
          margin: EdgeInsets.only(top: 30),
          child: Center(
            child: Text(
              'Erreur : source de la référence non trouvée ', style: TextStyle(fontSize: 25),),
          ),
        );
      } else {
        return _createMainBodyContent();
      }
    }
  }

  Widget _createMainBodyContent() {
    var size = MediaQuery
        .of(context)
        .size;
    final double itemWidth = size.width;
    return Column(
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
                  _filterActivites();
                });
              },
              decoration: InputDecoration(
                // labelText: "Search",
                hintText: "Rechercher une activité...",
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
            color: MyAppColors.primaryColor,
          ),
        ),

        Expanded(
          child: _createActiviteListView(),
        ),
      ],
    );
  }

  Widget _createActiviteListView() {
    var size = MediaQuery
        .of(context)
        .size;
    /*24 is for notification bar on Android*/
    final double itemHeight = ((size.height - kToolbarHeight - 24) / 2) +
        ((size.height - kToolbarHeight - 24) / 6);
    final double itemWidth = size.width - 30;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: itemHeight,
        width: itemWidth,
        margin: EdgeInsets.only(top: 30, bottom: 0, left: 7, right: 7),
        padding: EdgeInsets.all(3.0),
        child: ListView.builder(
          itemCount: _filteredActivites.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, i) =>
              _createActiviteWidget(_filteredActivites[i]),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: MyAppColors.primaryColor.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
          // border: Border.all(color: MyAppColors.primaryColor, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  Widget _createActiviteWidget(Activite activite) {
    return new Card(
      margin: EdgeInsets.only(bottom: 7,),
      child: new Container(
        padding: new EdgeInsets.all(3.0),
        child: new Column(
          children: <Widget>[
            new ListTile(
              title: Column(
                children:[
                  new Text(
                    activite.nom, style: TextStyle(fontSize: 20, color: Colors.white),),
                  activite.clubActivite!=null?new Text(
                    activite.clubActivite.nom, style: TextStyle(fontSize: 20, color: Colors.white),):
                  new Text(""),
                  activite.prix!=null?new Text(
                    activite.prix.toString(), style: TextStyle(fontSize: 17, color: Colors.white,),
                    textAlign: TextAlign.right,):
                  new Text("gratuit"),
                ]
              ),
              onTap: () => {
                print("onclick activite "+ activite.nom),
              Navigator.push(
              context,
              MaterialPageRoute(
              builder:
              (context) =>
                  ActiviteDetailsPage(activite: activite))),
              },
              tileColor: MyAppColors.secondaryColor,
              selectedTileColor: MyAppColors.primaryColor,
              subtitle: new Text((activite.lieu != null
                  ? activite.lieu
                  : "")),
              focusColor: MyAppColors.secondaryColor,
              contentPadding: EdgeInsets.all(5.0),
            )
          ],
        ),
      ),
    );
  } // create
  }