import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jungle/core/model/enfant.dart';
import 'package:jungle/core/model/representant.dart';
import 'package:jungle/core/service/enfant-service.dart';
import 'package:jungle/core/util/MyAppColors.dart';
import 'package:jungle/main.dart';
import 'package:jungle/ui/create-beneficiaire.dart';

import 'app-drawer.dart';

Representant representantG;
class ListBeneficiairesPage extends StatefulWidget {
  final Representant representant;
  ListBeneficiairesPage({@required this.representant}){
    representantG=this.representant;
  }
  @override
  _ListBeneficiairesPageState createState() => _ListBeneficiairesPageState();
}

class _ListBeneficiairesPageState extends State<ListBeneficiairesPage> {
  final _enfantService = new EnfantService();
  List<Enfant> _enfants = [],
      _filteredEnfants = [],
      _selectedEnfants = [];
  String _searchValue;
  List<int> _checkedIds = [];
  bool _loading = true,
      _noEnfantfounded = true;

  @override
  void initState() {
    super.initState();
    _fetchEnfants();
  }

  _fetchEnfants() async {
    await _enfantService.getEnfantsByRepresentant(representantG.id).then((response) =>
    {
      if(response.statusCode == HttpStatus.ok){
        setState(() {
          _enfants = (jsonDecode(Utf8Decoder().convert(response.body.codeUnits)).
          map((i) => Enfant.fromJson(i)).toList())
              .cast<Enfant>().toList();
          _filteredEnfants = _enfants;
          _loading = false;
          if (_filteredEnfants.isNotEmpty)
            _noEnfantfounded = false;
          else
            _noEnfantfounded = true;
          _checkedIds.clear();
        }),
      }
    });
  }

  void _filterEnfants() {
    if (_searchValue != null && _searchValue != '') {
      print('search in ' + _searchValue);
      _searchValue = _searchValue.toLowerCase().trim();
      setState(() {
        _filteredEnfants = _enfants.where((enfant) =>
        enfant.nom != null &&
            enfant.nom.toLowerCase().contains(_searchValue)
        ).toList();
      });
    } else {
      setState(() {
        _filteredEnfants = _enfants;
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
          child: Text('loading...', style: TextStyle(fontSize: 25),),
        ),
      );
    } else {
      if (_noEnfantfounded) {
        return Container(
          margin: EdgeInsets.only(top: 30),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Aucun bénéficiaire trouvé ', style: TextStyle(fontSize: 25),),
                ElevatedButton(
                  style: ButtonStyle(minimumSize: MaterialStateProperty.all<Size>(Size(150,50))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder:
                                (context) =>
                                CreateBeneciairePage(representant: representantG)));
                  },
                  child: Text(
                      "Nouveau"
                  ),
                ),
              ],
            )

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
                  _filterEnfants();
                });
              },
              decoration: InputDecoration(
                // labelText: "Search",
                hintText: "Rechercher un bénéficiaire...",
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
          child: _createEnfantListView(),
        ),

        SizedBox(height: 5),
        ElevatedButton(
          style: ButtonStyle(minimumSize: MaterialStateProperty.all<Size>(Size(150,50))),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder:
                        (context) =>
                            CreateBeneciairePage(representant: representantG)));
          },
          child: Text(
              "Nouveau"
          ),
        ),
      ],
    );
  }

  Widget _createEnfantListView() {
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
          itemCount: _filteredEnfants.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, i) =>
              _createEnfantWidget(_filteredEnfants[i]),
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

  Widget _createEnfantWidget(Enfant enfant) {
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
                      enfant.nom, style: TextStyle(fontSize: 20, color: Colors.white),),
                    new Text(
                      enfant.prenom, style: TextStyle(fontSize: 20, color: Colors.white),),
                  ]
              ),
              onTap: () => {
                print("onclick enfant "+ enfant.nom),

              },
              tileColor: MyAppColors.secondaryColor,
              selectedTileColor: MyAppColors.primaryColor,
              subtitle: new Text((enfant.dateNaissance != null
                  ? enfant.dateNaissance
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