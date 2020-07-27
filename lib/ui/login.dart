import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:questionario_app/model/login_api.dart';
import 'package:questionario_app/ui/home.dart';


class Login extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginApi login = LoginApi();
  final userController = TextEditingController();
  final senhaController = TextEditingController();
  SnackBar snack;
  String errorLogin;
  bool loginErro = false;
  bool connect = true;
  bool _isloading = false;
  void initState() {
    super.initState();
    //checkConnect();
  }

  /*void checkConnect() async {
    bool connected;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      connected = true;
    } else if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      connected = true;
    } else {
      connected = false;
    }
    setState(() {
      connect = connected;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(63, 183, 171, 1),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/bkg.jpg'),
                        fit: BoxFit.fill)),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                  child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, .2),
                              blurRadius: 20.0,
                              offset: Offset(0, 10))
                        ]),
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: userController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Login",
                                  hintText: "Login",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                            Divider(),
                            TextFormField(
                              obscureText: true,
                              controller: senhaController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Senha",
                                  hintText: "Senha",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ],
                        )),
                  )),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                  onTap: () {
                    Future<bool> retorno = logar(userController.text, senhaController.text);
                    //print(retorno);
                    if(retorno==false) {
                      snack = SnackBar(
                        content: Text(errorLogin),
                      );
                      Scaffold.of(context).showSnackBar(snack);
                    }
                  },
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                      child: Container(
                        height: 50,
                        width: 400,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(253, 122, 0, 1),
                              Color.fromRGBO(253, 122, 0, 1),
                            ])),
                        child: Center(
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0),
                          ),
                        ),
                      ))),
              Container(
                padding: EdgeInsets.all(20.0),
                  child: connect == false ? Center(child:Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.warning,color: Colors.yellow,size: 40.0,),
                      Text("Sem conexão com internet", style: TextStyle(color: Colors.white,fontSize: 20.0),)
                    ],
                  )) : null,
              ),
              Container(
                padding: EdgeInsets.all(30.0),
                child: _isloading
                    ? CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.deepOrange),
                      )
                    : Text(""),
              ),

            ],
          ),
        ),
      ),
    );
  }
  /*Future<bool> _requestPop(){
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
}*/

  Future<bool> logar(String user, String senha) async {
    bool _login = false;
    login.user = user;
    login.pass = senha;
    setState(() {
      _isloading = true;
    });

    login.login().then((list) async {
      setState(() {

        _isloading = false;
        if(list==null){
          connect = false;
        }else{
          connect = true;
          if(list['login']==false){
            loginErro = true;
            errorLogin = list['msg'];

          }else {
            Navigator.pop(context);
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));

          }
        }

      });
      /**/
    });

    return _login;
  }
}
