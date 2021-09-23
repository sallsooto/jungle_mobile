import 'dart:convert';

import 'package:jungle/core/model/representant.dart';
import 'package:jungle/core/service/enfant-service.dart';
import 'package:jungle/core/service/user-details-service.dart';
import 'package:jungle/main.dart';
import 'package:jungle/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jungle/ui/create-beneficiaire.dart';
import 'package:jungle/ui/list-beneficiaires.dart';
import 'package:jungle/ui/login.dart';

class AppDrawer extends StatefulWidget {

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final storage = new FlutterSecureStorage();
  final UserDetailsService userDetailsService = new UserDetailsService();
  final EnfantService enfantService= new EnfantService();
  Representant representantG= new Representant();
  int _representUserIdG=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRepresentantUserIdIfConnected();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _drawerHeader(),
          _createDrawerItem(
              icon: Icons.home,
              text: 'Accueil',
              onTap: () =>
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder:
                              (context) =>
                              MyHomePage()))),
          _representUserIdG!=0?
          _createDrawerItem(
              icon: Icons.home,
              text: 'Bénéficiaires',
              onTap: () =>{
                enfantService.getRepresentantByUserId(_representUserIdG)
                    .then((response) => {
                      representantG = (jsonDecode(response.body).
                map((i) => Representant.fromJson(i)).toList())
                    .cast<Representant>().toList()[0],
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder:
                              (context) =>
                                  ListBeneficiairesPage(representant: representantG))),
                })
              }
                  ):new Text(""),
          _representUserIdG!=0?
          _createDrawerItem(
              icon: Icons.logout,
              text: 'Déconnexion',
              onTap: () =>{
              storage.delete(key: 'token'),
              storage.delete(key: 'userDetails'),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder:
                            (context) =>
                                MyHomePage())),
              }):
          _createDrawerItem(
              icon: Icons.logout,
              text: 'Connexion',
              onTap: () =>{
                storage.delete(key: 'token'),
                storage.delete(key: 'userDetails'),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder:
                            (context) =>
                            LoginPage())),
              })
        ],
      ),
    );
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

  Widget _drawerHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/logo.png'),
            alignment: Alignment.center,
          ),
        ),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

}
