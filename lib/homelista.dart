// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:consumo_servico_avancado/post.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:html';
import 'package:flutter/material.dart';


class HomeLista extends StatefulWidget {
  const HomeLista({ Key? key }) : super(key: key);

  @override
  State<HomeLista> createState() => _HomeListaState();
}

class _HomeListaState extends State<HomeLista> {

  String _urlBase = 'https://jsonplaceholder.typicode.com/';

  Future<List<Post>> _recuperarPostagens() async {
    http.Response response = await http.get(_urlBase + '/posts');
    var dadosJson = json.decode( response.body );

    List<Post> postagens = [];
    for( var post in dadosJson ){
      Post p = Post(post['userId'], post['id'], post['title'], post['body']);
      postagens.add(p);
    }
    return postagens;
  }

  _post(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumo de serviço avançado'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: _post, 
                  child: Text('Salvar')
                ),
              ],
            ),
            
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _recuperarPostagens(),
                builder: (context, snapshot){
                  var retorno;
                  
                  // Ponto de decisão em conectividade
                  switch( snapshot.connectionState ){

                    case ConnectionState.none :  
                    retorno = const Center(
                      child: Text('Falha no sistema'),
                    );
                    break;

                    case ConnectionState.waiting : 
                    retorno = const Center(
                      child: CircularProgressIndicator(),
                    );
                    break;

                    case ConnectionState.active : 
                    retorno = const Center(
                      child: Text('ativo'),
                    );
                    break;

                    case ConnectionState.done : 
                    
                      if( snapshot.hasError ){
                        print('Erro ao carregar');
                      }else{
            
                        retorno = ListView.builder(
                          itemCount: snapshot.data?.length,
                            itemBuilder: (context, index){
            
            
                              //(List<Post>?)Configurar a lista  (lista) nome da lista  (snapshot.data)recuperar dados
                              List<Post>? lista = snapshot.data;
                              Post post = lista![index];
                              
                              return ListTile(
                                title: Text(post.title),
                                subtitle: Text(post.id.toString()),
                              );
                            },
                        );
                      }
                    break;
                  }
                  return retorno;           
                },
              ),
            )


  
          ],
        ),
      ),
    );
  }
}