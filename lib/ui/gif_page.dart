import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class GifPage extends StatelessWidget {
  const GifPage({super.key,  required this.gifData});

  final Map gifData;





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gifData["title"],
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {
                SharePlus.instance.share (
                  ShareParams(
                    text:   (gifData as Map<String, dynamic>)["images"]["fixed_height"]["url"]
                  ),

                );


              },
              icon: Icon(Icons.share, color: Colors.white,),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network((gifData as Map<String, dynamic>)["images"]["fixed_height"]["url"]),
      ),
    );
  }


}





