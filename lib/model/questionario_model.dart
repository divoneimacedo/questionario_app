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
    final path =  join(databasesPath,"questionario.db");
    return await openDatabase(path,version: 1,onCreate: (Database db,int newerversion) async{
      await db.execute(
          "CREATE TABLE $questTable ($idColumn INTEGER PRIMARY KEY,$cpfColumn TEXT,$nomeColumn TEXT, $telColumn TEXT, $generoColumn TEXT, $cidadeColumn TEXT, $ufColumn TEXT)"
      );
    });
  }

  Future<List> getDataQuest() async{
    Database dbQuest = await db;
    List listMap = await dbQuest.rawQuery("Select * FROM $questTable");
    List<Questionario> listQuest = List();
    for(Map m in listMap){
      listQuest.add(Questionario.fromMap(m));
    }
  }

  Future<Questionario> saveQuest(Questionario quest) async{
    Database dbQuest = await db;
    quest.id = await dbQuest.insert(questTable, quest.toMap());
    return quest;
  }

  Future<int> updateQuest(Questionario quest) async {
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

class Questionario{
  int id;
  String cpf;
  String nome;
  String genero;
  String cidade;
  String uf;
  String telefone;

  Questionario();

  Questionario.fromMap(Map map){
    id = map[idColumn];
    cpf = map[cpfColumn];
    nome = map[nomeColumn];
    genero = map[generoColumn];
    cidade = map[cidadeColumn];
    uf = map[ufColumn];
    telefone  = map[telColumn];
  }

  Map toMap(){
   Map<String,dynamic> map = {
     cpfColumn: cpf,
     nomeColumn: nome,
     telColumn:telefone,
     generoColumn:genero,
     cidadeColumn:cidade,
     ufColumn:uf
   };

   if(id != null){
     map[idColumn] = id;
   }

   return map;
  }

  @override
  String toString(){
    return "Questionario(cpf:$cpf,nome: $nome,telefone:$telefone,genero:$genero,cidade:$cidade,uf:$uf)";
  }
}
