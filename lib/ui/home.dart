import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
class Home extends StatelessWidget{
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

  final cpfController = TextEditingController();
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final cidadeController = TextEditingController();
  final ufController = TextEditingController();

  var maskTel = MaskTextInputFormatter(mask: "(##) #####-####", filter: { "#": RegExp(r'[0-9]') });
  var maskCPF = MaskTextInputFormatter(mask: "###.###.###-##", filter: { "#": RegExp(r'[0-9]') });
  //var maskDefault = MaskTextInputFormatter(mask: "#", filter: { "#": RegExp(r'[A-Za-z0-9]') });
  Genero _genero;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Questionário"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: (){}

          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Padding(
          padding: EdgeInsets.all(10),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                  buildTextField("CPF", cpfController, maskCPF, TextInputType.number),
                  Divider(),
                  buildTextField("Nome", nomeController, null, TextInputType.text),
                  Divider(),
                  buildTextField("Telefone", telefoneController, maskTel, TextInputType.phone),
                Divider(),
                DropdownButton<Genero>(
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
                      print(_genero.name);
                    });
                  },
                )

              ],

          
        )),
      ),
    );
  }

  Widget buildTextField(String label,TextEditingController c,MaskTextInputFormatter m,TextInputType t){
    if(m!=null)
      return TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        controller: c,
        inputFormatters: [ m ],
        keyboardType: t,
      );
    else
      return TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        controller: c,
        keyboardType: t,
      );

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
