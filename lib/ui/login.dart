import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Login",
                                hintText: "Login",
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                          TextFormField(
                            obscureText: true,
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
                  print("apertou");
                },
                child: Container(
                  height: 50,
                  width: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(63, 183, 171, .7),
                        Color.fromRGBO(63, 183, 171, .4),
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
                ))
          ],
        ),
      ),
    );
  }
}
