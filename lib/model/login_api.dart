import 'dart:convert';
import 'dart:developer';

import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

const url_api = "https://wssetup.webstorm.com.br/login_api.php";
class LoginApi{
  String _user_id;
  String _pass;

  void set user(String user){
    this._user_id = user;
  }

  void set pass(String pass){
    this._pass = pass;
  }



  Map<String,String> postBody(){
    Map<String,String> map = Map();
    map['login'] = this._user_id;
    map['senha'] = this._pass;
    return map;
  }

  Future<Map> login() async{
    Map<String,String> map = postBody();
    Map<String,dynamic> json;
    try {
      http.Response response = await http.post(url_api, body: map);
      if (response.statusCode == 200) {
        json = jsonDecode(response.body);

      } else {
        json['connection'] = false;
        json['msg'] = response.headers.toString();
      }
    }catch(e){
      print("erro");

    }
    return json;
  }
}