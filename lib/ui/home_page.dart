import 'dart:async';
import 'dart:convert';

import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   String? _search;
   int _offset = 0;

 Future<Map> _getGifs() async {
    http.Response response;
    //response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=R2UlnkxUb9hM9Nj7nBjpSZHrxts5jTaB&limit=20&offset=0&rating=g&bundle=messaging_non_clips"));
    //print(_search);
    //print("1OLLLLAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA1");
    if(_search == null || _search!.isEmpty) {
      //print("2OLLLLAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA2");
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=R2UlnkxUb9hM9Nj7nBjpSZHrxts5jTaB&limit=20&offset=0&rating=g&bundle=messaging_non_clips"));
    } else {
      //print("oadsfsd: $_search");
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=R2UlnkxUb9hM9Nj7nBjpSZHrxts5jTaB&q=$_search&limit=19&offset=$_offset&rating=g&lang=en&bundle=messaging_non_clips"));
    }

    return json.decode(response.body);


  }


  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map.toString());
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise Aqui!",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset= 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context,snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Container();
                      } else {
                        return  _createGifTable(context, snapshot);
                      }
                  }
                }
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
   if(_search == null) {
     return data.toList().length;
   } else {
     return data.toList().length +1;
   }
  }

Widget  _createGifTable(BuildContext context, AsyncSnapshot<Object?> snapshot){
   return GridView.builder(
       padding: EdgeInsets.all(10.0),
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: 2,
           crossAxisSpacing: 10.0,
           mainAxisSpacing: 10.0
       ),
       itemCount:  _getCount((snapshot.data! as Map<String, dynamic>)["data"]),
       itemBuilder: (context, index){
         if(_search == null || index < (snapshot.data as Map<String, dynamic>)["data"].length){
           var snap = (snapshot.data! as  Map<String, dynamic>)["data"][index]["images"]["fixed_height"]["url"];
           return GestureDetector(
             child: FadeInImage.memoryNetwork(
                 placeholder: kTransparentImage,
                 image: snap,
                 height: 300.0,
                 fit: BoxFit.cover,
             ),
             onTap: () {
               Navigator.push(context,
                 MaterialPageRoute(builder: (context) => GifPage(gifData: (snapshot.data as Map<String, dynamic>)["data"][index]))

               );
             },
             onLongPress: () {
               SharePlus.instance.share(
                 ShareParams(
                  text: (snapshot.data! as Map<String, dynamic>)["data"][index]["images"]["fixed_height"]["url"]
                 )
               );
             },
           );
         }else {
           return GestureDetector(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Icon(Icons.add, color: Colors.white, size: 70.0,),
                 Text("Carregar mais...",
                   style: TextStyle(color: Colors.white, fontSize: 22.0),
                 )
               ],
             ),
             onTap: (){
               setState(() {
                 _offset += 19;
               });
             },
           );
         }


       }
   );
}
}


