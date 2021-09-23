import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:jungle/core/model/enfant.dart';
import 'package:jungle/core/model/professionnel.dart';
import 'package:jungle/core/model/sous-univers.dart';
import 'package:jungle/core/model/univers.dart';
import 'package:jungle/core/service/professionel-service.dart';
import 'package:jungle/core/service/sous-univers-service.dart';
import 'package:jungle/core/service/univers-service.dart';

void main() => runApp(Application());
final _universService = new UniversService();
final _sousUniversService = new SousUniversService();
List<Univers> _univers = [];
List<SousUnivers> _sousUnivers = [];
class Application extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_bootstrap Demo',
      home: DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  bool _loading = true,
      _noUniversfounded = true;

  @override
  void initState() {
    super.initState();
    _chargerUnivers();
    _chargerSousUnivers();
    bootstrapGridParameters(
      gutterSize: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_bootstrap Demo', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: !_loading? BootstrapContainer(
          fluid: true,
          children: [
            BootstrapContainer(
              fluid: false,
              decoration: BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.only(top: 50),
              children: <Widget>[
                universWidgets(_univers),

                BootstrapRow(
                  height: 60,
                  children: <BootstrapCol>[
                    BootstrapCol(
                      sizes: 'col-12',
                      child: ContentWidget(
                        text: 'col 1 of 2',
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                BootstrapRow(
                  height: 60,
                  children: <BootstrapCol>[
                    BootstrapCol(
                      sizes: 'col-6',
                      child: ContentWidget(
                        text: 'col 1 of 3',
                        color: Colors.green,
                      ),
                    ),
                    BootstrapCol(
                      sizes: 'col-6',
                      child: ContentWidget(
                        text: 'col 2 of 3 (wider)',
                        color: Colors.red,
                      ),
                    ),
                    BootstrapCol(
                      sizes: 'col-6',
                      child: ContentWidget(
                        text: 'col 2 of 3 (wider)',
                        color: Colors.red,
                      ),
                    ),
                    BootstrapCol(
                      sizes: 'col-6',
                      child: ContentWidget(
                        text: 'col 2 of 3 (wider)',
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Divider(),
              ],
            ),
          ],
        ):Container(
          margin: EdgeInsets.only(top: 30),
          child: Center(
            child: Text('Chargement des univers...', style: TextStyle(fontSize: 25),),
          ),
        ),
      ),
    );
  }
  _chargerUnivers() async {
    await _universService.getUnivers().then((response) =>
    {
      if(response.body!=null && response.body!=""){
        setState(() {
          _univers = (jsonDecode(response.body).
          map((i) => Univers.fromJson(i)).toList())
              .cast<Univers>().toList();
          _loading = false;

          print("taille des univers:"+_univers.length.toString());

        }),
      }
    });
  }

  _chargerSousUnivers() async {
    await _sousUniversService.getSousUnivers().then((response) =>
    {
      if(response.body!=null && response.body!=""){
        setState(() {
          _sousUnivers = (jsonDecode(response.body).
          map((i) => SousUnivers.fromJson(i)).toList())
              .cast<SousUnivers>().toList();
          print("taille des univers:"+_sousUnivers.length.toString());
        }),
      }
    });
  }
}

class ContentWidget extends StatelessWidget {
  const ContentWidget({
    Key key,
    this.text,
    this.color,
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: color,
      child: Text(text),
    );
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
                  width: 500,
                  height: 150,
                  padding: EdgeInsets.all(10),
                  child:ContentWidget(
                    text: item.nom,
                    color: Colors.blue,
                  ),
                ),
                
                SizedBox(height: 8,)
              ],
            ),
          ),
          for (var i = 0; i < univers.length; i++)
            sousUniversWidgets(univers)[i]
        ],
      )).toList());
}

sousUniversWidgets(List<Univers> univers)
{
  final children = <Widget>[];
  for (var i = 0; i < univers.length; i++) {
    children.add(new BootstrapCol(
      sizes: 'col-6',
      child: Column(
        children: [
          SizedBox(height: 8,),
          Container(
            width: 60,
            height: 50,
            padding: EdgeInsets.all(10),
            child:ContentWidget(
              text: univers[i].nom,
              color: Colors.blue,
            ),
          ),
        ],
      )


    ));
  }
  return children;

}
