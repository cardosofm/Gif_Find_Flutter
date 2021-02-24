import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  // variável usada para determinar o tipo de busca que será feita na API
  // se null vai buscar os trendings
  // senão vai buscar pelo search da API
  String _searchType;

  //offset é a paginação da API
  int _offSet = 0;

  // Future e async pra retornar um dado no futuro e esperar a função terminar de carregar
  Future<Map> _getGifs() async {
    http.Response response;
    // escolher o tipo de busca
    if (_searchType == null) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=nPkg1cur4bPhqs59kpXTP1WvWoDTI1Ty&limit=10&rating=g");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=nPkg1cur4bPhqs59kpXTP1WvWoDTI1Ty&q=$_searchType&limit=20&offset=$_offSet&rating=g&lang=en");
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
   // _getGifs().then((map) => print(map["data"]));
    print("Foi!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Search",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            )
          ],
        ),
      ),
    );
  }
}
