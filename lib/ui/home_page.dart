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
    if (_searchType == null || _searchType == "") {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=nPkg1cur4bPhqs59kpXTP1WvWoDTI1Ty&limit=48&rating=g");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=nPkg1cur4bPhqs59kpXTP1WvWoDTI1Ty&q=$_searchType&limit=47&offset=$_offSet&rating=g&lang=pt");

    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) => print(map["data"]));
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
            Center(
              child: Text(
                "Buscador de Gifs da Pietra",
                style: TextStyle(color: Colors.white, fontSize: 22.0),
              ),
            ),
            Divider(),
            TextField(
              decoration: InputDecoration(
                  labelText: "Digite algo aqui para procurar",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              onSubmitted: (text) {
                setState(() {
                  _searchType = text;
                  _offSet = 0;
                });
              },
            ),
            Divider(),
            // fazendo carregamento dos gifs usando future builder
            // mostrando um progress indicator
            Expanded(
                child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 100.0,
                      height: 100.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );

                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else
                      return _creatGifTable(context, snapshot);
                }
              },
            ))
          ],
        ),
      ),
    );
  }

  // funcao para pegar o numero de itens que veio da API
  int _getCount(List data) {
    if (_searchType == null || _searchType == "") {
      return data.length;
    }
    // vai colocar um item a mais para poder fazer o botão de carregamento de mais itens
    return data.length + 1;
  }

  //contrução da tabela de gifs
  Widget _creatGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        // colocando o tamanho da lista
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (_searchType == null || index < snapshot.data["data"].length)
            return GestureDetector(
              child: Image.network(
                snapshot.data["data"][index]["images"]["fixed_height_small"]
                    ["url"],
                height: 100.0,
                fit: BoxFit.cover,
              ),
            );
          else
            return Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _offSet += 47;
                  });
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                        size: 50.0,
                      ),
                      Text(
                        "Carregar mais",
                        style: TextStyle(color: Colors.white, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            );
        });
  }
}
