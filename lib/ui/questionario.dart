import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:questionario_app/model/questionario_model.dart';
class Questionario extends StatelessWidget{
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        /*visualDensity: VisualDensity.adaptivePlatformDensity,*/
      ),
      home: QuestionarioPage(),
    );
  }
}

class QuestionarioPage extends StatefulWidget {
  final QuestionarioList questionarioList;
  QuestionarioPage({ this.questionarioList });
  @override
_QuestionarioPageState createState() => _QuestionarioPageState();
}

class _QuestionarioPageState extends State<QuestionarioPage> {

  final cpfController = TextEditingController();
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final cidadeController = TextEditingController();
  final ufController = TextEditingController();

  final _nameFocus = FocusNode();

  var maskTel = MaskTextInputFormatter(mask: "(##) #####-####", filter: { "#": RegExp(r'[0-9]') });
  var maskCPF = MaskTextInputFormatter(mask: "###.###.###-##", filter: { "#": RegExp(r'[0-9]') });
  //var maskDefault = MaskTextInputFormatter(mask: "#", filter: { "#": RegExp(r'[A-Za-z0-9]') });
  Genero _genero;
  Uf _uf;
  bool _userEdited = false;
  QuestionarioList _editQuest;

  @override
  void initState() {
    super.initState();
    
    if(widget.questionarioList == null){
      _editQuest = QuestionarioList();
      _editQuest.send = 0;
      _editQuest.img = "";
    } else {
      _editQuest = QuestionarioList.fromMap(widget.questionarioList.toMap());

      nomeController.text = _editQuest.nome;
      cpfController.text = _editQuest.cpf;
      telefoneController.text = _editQuest.telefone;
    }
    print(_editQuest);
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: _requestPop,
        child:Scaffold(
      appBar: AppBar(
        title: Text(_editQuest.nome ?? "Novo Questionário"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(_editQuest.nome != null && _editQuest.nome.isNotEmpty){
            Navigator.pop(context, _editQuest);
          } else {
            FocusScope.of(context).requestFocus(_nameFocus);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Padding(
          padding: EdgeInsets.all(10),
            child:Column(
              crossAxisAlignment:CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                  buildTextField("CPF", cpfController, maskCPF, TextInputType.number,(text){ _userEdited = true; setState(() { _editQuest.cpf = text; }); }),
                  Divider(),
                  buildTextField("Nome", nomeController, null, TextInputType.text,(text){ _userEdited = true; setState(() { _editQuest.nome = text; }); }),
                  Divider(),
                  Container(
                    child:DropdownButton<Genero>(
                      isExpanded: true,
                      underline: SizedBox(),
                      value: _genero,
                      hint: Text("Selecione o Gênero"),
                      items: Genero.getGeneros().map((Genero gen) {
                        return DropdownMenuItem<Genero>(
                          value: gen,
                          child: Text(gen.name),
                        );
                      }).toList(),

                      onChanged: (Genero val) {
                        setState(() {
                          _genero = val;
                          _editQuest.genero = _genero.id;
                          //print(_genero.name);
                        });
                      },
                    )
                ),
                Divider(),
                buildTextField("Cidade", cidadeController, null, TextInputType.text,(text){ _userEdited = true; setState(() { _editQuest.cidade = text; }); }),
                Divider(),
                Container(
                    child:DropdownButton<Uf>(
                      isExpanded: true,
                      underline: SizedBox(),
                      value: _uf,
                      hint: Text("Estado"),
                      items: Uf.getUf().map((Uf uf) {
                        return DropdownMenuItem<Uf>(
                          value: uf,
                          child: Text(uf.name),
                        );
                      }).toList(),

                      onChanged: (Uf val) {
                        setState(() {
                          _uf = val;
                          _editQuest.uf = _uf.id;
                          //print(_genero.name);
                        });
                      },
                    )
                ),
                Divider(),
                buildTextField("Telefone", telefoneController, maskTel, TextInputType.phone,(text){ _userEdited = true; setState(() { _editQuest.telefone = text; if(text.length==14) maskTel.updateMask("(##) ####-####"); else maskTel.updateMask("(##) #####-####");   }); }),
              ],

          
        )),
      ),
    ));
  }

  Widget buildTextField(String label,TextEditingController c,MaskTextInputFormatter m,TextInputType t,Function f){
    if(m!=null)
      return TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        controller: c,
        inputFormatters: [ m ],
        keyboardType: t,
        onChanged: f,
      );
    else
      return TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        controller: c,
        keyboardType: t,
        onChanged: f,
      );

  }
  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}


class Genero {
  final String id;
  final String name;

  Genero(this.id, this.name);

  static List<Genero> getGeneros() {
    return <Genero>[
      Genero('M', 'Masculino'),
      Genero('F', 'Feminino'),
      Genero('N', 'Não binário'),
    ];
  }

  @override
  String toString() {
    return name;
  }

  bool operator == (Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Genero && other.id == id && other.name == name;
  }
}

class Uf{
  final String id;
  final String name;

  Uf(this.id, this.name);

  static List<Uf> getUf() {
    return <Uf>[
      Uf('AC', 'Acre'),
      Uf('AL', 'Alagoas'),
      Uf('AM', 'Amazonas'),
      Uf('CE', 'Ceará'),
      Uf('DF', 'Distrito Federal'),
      Uf('MS', 'Mato Grosso do Sul'),
      Uf('MG', 'Minas Gerais'),
      Uf('PR', 'Paraná'),
      Uf('RJ', 'Rio de Janeiro'),
      Uf('RS', 'Rio Grande do Sul'),
      Uf('SC', 'Santa Catarina'),
      Uf('SP', 'São Paulo'),
    ];
  }

  @override
  String toString() {
    return name;
  }

  bool operator == (Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Uf && other.id == id && other.name == name;
  }
}
