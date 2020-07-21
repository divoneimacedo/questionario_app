import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:questionario_app/model/questionario_model.dart';
import 'questionario.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum SendOptions  {send}

class Home extends StatelessWidget{
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Questionário',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        /*visualDensity: VisualDensity.adaptivePlatformDensity,*/
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //instancia modelo
  QuestionarioModel questionario = QuestionarioModel();
  List<QuestionarioList> listForm = List();

  @override
  void initState(){
    super.initState();
    _getAllForms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dados preenchidos"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<SendOptions>(
            itemBuilder: (context) => <PopupMenuEntry<SendOptions>>[
              const  PopupMenuItem(
                child: Text("Enviar questionários pendentes"),
                value: SendOptions.send,
              )
            ],
            onSelected: _sendForms,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _showFormPage,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: listForm.length,
          itemBuilder: (context,index){
            return _formCard(context,index);
          }
      )
      ,
    );
  }

  void _sendForms(SendOptions result) async{

  }

  Widget _formCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: listForm[index].img != null ?
                      FileImage(File(listForm[index].img)) :
                      AssetImage("images/person.png"),
                      fit: BoxFit.cover
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(listForm[index].nome ?? "",
                      style: TextStyle(fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(listForm[index].cpf ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(listForm[index].telefone ?? "",
                      style: TextStyle(fontSize: 18.0),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Ligar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          launch("tel:${listForm[index].telefone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                          _showFormPage(questionarioList: listForm[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          questionario.deleteQuest(listForm[index].id);
                          setState(() {
                            listForm.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
    );
  }

  void _showFormPage({QuestionarioList questionarioList}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => QuestionarioPage(questionarioList: questionarioList,))
    );
    if(recContact != null){
      if(questionarioList != null){
        await questionario.updateQuest(recContact);
      } else {
        await questionario.saveQuest(recContact);
      }
      _getAllForms();
    }
  }

  void _getAllForms(){
    questionario.getDataQuest().then((list) {
      setState(() {
        listForm = list;
      });
    });
  }
}

