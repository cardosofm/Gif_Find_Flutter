import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(_gifData["images"]["fixed_height"]["url"]);
            },
          ),
        ],
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Gif Escolhido"),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _gifData["title"],
              style: TextStyle(color: Colors.white),
            ),
            Divider(),
            Image.network(_gifData["images"]["fixed_height"]["url"]),
          ],
        ),
      )
          /*Image.network(_gifData["images"]["fixed_height_small"]["url"]),*/
          ),
    );
  }
}
