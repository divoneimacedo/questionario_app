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
  bool _isloading = false;
  /*void initState(){
    super.initState();
    login.user = "divonei";
    login.pass = "wsteste2011";
    login.login().then((list) {
      print(list);
    } );
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
                    logar(userController.text, senhaController.text);
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

  void logar(String user, String senha) async {
    login.user = user;
    login.pass = senha;
    setState(() {
      _isloading = true;
    });
    login.login().then((list) async{

      setState(() {
        _isloading = false;
      });
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage()));
    });
  }
}
