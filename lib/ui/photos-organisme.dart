import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jungle/Animation/FadeAnimation.dart';
import 'package:jungle/core/config/api-config.dart';
import 'package:jungle/core/model/club.dart';
import 'package:jungle/core/model/jwt-token.dart';
import 'package:jungle/core/model/photo.dart';
import 'package:jungle/core/model/user-details.dart';
import 'package:jungle/core/service/photo-service.dart';
import 'package:jungle/core/service/user-details-service.dart';
import 'package:jungle/core/util/MyAppColors.dart';

import '../main.dart';

Club organisme;

List<Photo> _photos = [];
List<Photo> _p = [];
List imageUrl = [];

class PhotoOrganisme extends StatefulWidget {

  final Club club;
   PhotoOrganisme({@required this.club}){
    organisme = this.club;
  }
  @override
  _PhotoOrganismeState createState() => _PhotoOrganismeState();
}

class _PhotoOrganismeState extends State<PhotoOrganisme> {
  final  PhotoService _photoService = new PhotoService();
  Map<String, dynamic> tokenJson;
  JWTToken jwtToken;
  final storage = new FlutterSecureStorage();
  UserDetails userDetails;
  final UserDetailsService userDetailsService = new UserDetailsService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar (
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
      body: (
       Container(
         child: FadeAnimation(0.7,
             _buildImageColumn(),
           //_chargerPhotos(),
         ),
       )
         /* GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: imageUrl?.length,
              itemBuilder: (BuildContext context,int index){
                return Image.network(imageUrl)
              }
          )*/
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    //_chargerPhotos();
    //imageUrl;
   // _p;
   // convertImage();
  }
  _chargerPhotos() async{

    await _photoService.getUriPhot().then((value) => {
      if(value.body!=null && value.body!=''){
          setState((){
            _photos = (jsonDecode(value.body).map((i)=>Photo.fromJson(i)).toList()).cast<Photo>().toList();
            //_p = (jsonDecode(value.body).map((items) => items.clubToPhoto.id == organisme.id));

            _photos.forEach((element) {
              if(element.photoToClub.id == organisme.id ){
              //  _p.add(element);
                print(element.imageContentType);
                new ListView.builder(
                    itemCount: _photos.length,
                    itemBuilder: (context,int index){
                      var decoImage = element.image;
                      Uint8List img = Base64Decoder().convert(decoImage);
                      return new SingleChildScrollView(
                        child: Container(
                          child: img==null?Text('Image Note Value'):
                              Image.memory(img),
                        ),
                      );
                    }
                );
               // imageUrl.add([ApiConfig.URI+'/api/photos/'+element.id.toString()]);
              }
            });
            //print('la Taille'+_photos.length.toString());
          }),
      }
    });
  }

  ListTile _tiles(String title,String subTitle){
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20
        ),
      ),
      subtitle: Text(subTitle),
      leading: Icon(
        Icons.add,
      ),
    );

  }
  Widget _buildList(){

    return ListView(
      children: [
        _tiles('Premier de la lise', '1 er' ),
        const Divider(),
        const Divider(),
      ],
    );
  }

  Widget _buildDecoratedImage() =>Expanded(

    child:Container(

      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(width: 5,color: MyAppColors.secondaryColor,),
      ),
      margin: const EdgeInsets.all(4),
      //child: Icon(Icons.print),
      child: Image.asset('assets/images/bg2.jpg'),
      //child: Image.network(ApiConfig.URI+'/api/photos/'+'4551'),
     // child: Image.network('https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-1.jpg'),
     // child: Image.network('https://s3-us-west-2.amazonaws.com/appsdeveloperblog.com/images/cats/cat-1.jpg'),
    ),
  );
void convertImage(){
  if(_p.isNotEmpty){
    print('La taille'+_p.length.toString());
  }else{
    print('la liste des image est vide');
  }
}

  Widget _buildImageRow() =>Row(
    children: [
      _buildDecoratedImage(),

     _buildDecoratedImage(),
     /* _buildDecoratedImage(),
      _buildDecoratedImage(),*/
    ],
  );

  Widget _buildImageColumn(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          _buildImageRow(),


        ],
      ),
    );
  }
}
