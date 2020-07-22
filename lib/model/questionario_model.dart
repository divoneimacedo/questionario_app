import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String idColumn = "id";
final String questTable = "questionario";
final String cpfColumn = "cpf";
final String nomeColumn = "nome";
final String telColumn = "telefone";
final String generoColumn = "sexo";
final String cidadeColumn = "cidade";
final String ufColumn = "uf";
final String imgColumn = "img";
final String sendColumn = "send";

class QuestionarioModel{
  static final QuestionarioModel _instance = QuestionarioModel.internal();
  factory QuestionarioModel() => _instance;

  QuestionarioModel.internal();

  Database _db;

  Future<Database> get db async{
    if(_db!=null){
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }


  Future<Database> initDb() async{
    final databasesPath = await getDatabasesPath();
    final path =  join(databasesPath,"questionarionew.db");
    return await openDatabase(path,version: 1,onCreate: (Database db,int newerversion) async{
      await db.execute(
          "CREATE TABLE $questTable ($idColumn INTEGER PRIMARY KEY,$cpfColumn TEXT,$nomeColumn TEXT, $telColumn TEXT, $generoColumn TEXT, $cidadeColumn TEXT, $ufColumn TEXT,$imgColumn TEXT, $sendColumn INTEGER)"
      );
    });
  }
  
  Future<int> deleteQuest(int id) async{
    Database dbQuest = await db;
    return await dbQuest.delete(questTable,where: "$idColumn = ?",whereArgs: [id]);
  }

  Future<List> getDataQuest() async{
    Database dbQuest = await db;
    List listMap = await dbQuest.rawQuery("Select * FROM $questTable");
    //print(listMap);
    List<QuestionarioList> listQuest = List();
    for(Map m in listMap){

      listQuest.add(QuestionarioList.fromMap(m));
    }
    return listQuest;
  }

  Future<QuestionarioList> saveQuest(QuestionarioList quest) async{
    Database dbQuest = await db;
    quest.id = await dbQuest.insert(questTable, quest.toMap());
    return quest;
  }

  Future<int> updateQuest(QuestionarioList quest) async {
    Database dbContact = await db;
    return await dbContact.update(questTable,
        quest.toMap(),
        where: "$idColumn = ?",
        whereArgs: [quest.id]);
  }


  Future close() async{
    Database dbQuest = await db;
    dbQuest.close();
  }


}

class QuestionarioList{
  int id;
  String cpf;
  String nome;
  String genero;
  String cidade;
  String uf;
  String telefone;
  String img;
  int send;

  QuestionarioList();

  QuestionarioList.fromMap(Map map){
    print(map[idColumn]);
    id = map[idColumn];
    cpf = map[cpfColumn];
    nome = map[nomeColumn];
    genero = map[generoColumn];
    cidade = map[cidadeColumn];
    uf = map[ufColumn];
    telefone  = map[telColumn];
    img = map[imgColumn];
    send = map[sendColumn];
  }

  Map toMap(){
   Map<String,dynamic> map = {
     cpfColumn: cpf,
     nomeColumn: nome,
     telColumn:telefone,
     generoColumn:genero,
     cidadeColumn:cidade,
     ufColumn:uf,
     imgColumn:img,
     sendColumn:send
   };
   if(id != null){
     map[idColumn] = id;
   }

   return map;
  }

  @override
  String toString(){
    return "Questionario(cpf:$cpf,nome: $nome,genero:$genero,cidade:$cidade,uf:$uf,telefone:$telefone,img:$img,send:$send)";
  }
}

