import 'dart:async';
import 'dart:io';
import 'package:app_bd/models/pessoa.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

//usado para definir as colunas da tabela
  String pessoaTable = 'pessoa';
  String colId = 'id';
  String colNome = 'nome';
  String colTelefone = 'telefone';
  String colImagem = 'imagem';

  //construtor nomeado para criar instânia da classe
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      //executado somente uma vez
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'pessoas.db';

    var pessoaDatabase =
        await openDatabase(path, version: 1, onCreate: _createdDb);
    return pessoaDatabase;
  }

  void _createdDb(Database db, int newVersion) async {
    await db.execute(
        '''CREATE TABLE $pessoaTable(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colNome TEXT,
        $colTelefone TEXT,
        $colImagem TEXT)''');
  }

  //Incluir um objeto contato no banco de dados
  Future<int> insertPessoa(Pessoa pessoa) async {
    Database db = await this.database;

    var resultado = await db.insert(pessoaTable, pessoa.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return resultado;
  }

  //retornar pessoas pelo nome
  Future<Pessoa> getPessoa(String nome) async {
    Database db = await this.database;

    List<Map> maps = await db.query(pessoaTable,
        columns: [
          colId,
          colNome,
          colTelefone,
          colImagem,
        ],
        where: "$nome = ?",
        whereArgs: [nome]);

    return Pessoa.fromMap(maps.first);
  }

  //retornar todas as pessoas
  Future<List<Pessoa>> getPessoas() async {
    Database db = await this.database;

    var resultado = await db.query(pessoaTable);

    List<Pessoa> lista = resultado.isNotEmpty
        ? resultado.map((c) => Pessoa.fromMap(c)).toList()
        : [];

    return lista;
  }

  //Atualizar o objeto Pessoa do banco de dados

  Future<int> updatePessoa(Pessoa pessoa) async {
    var db = await this.database;

    var resultado = await db.update(pessoaTable, pessoa.toMap(),
        where: '$colId = ?', whereArgs: [pessoa.id]);

    return resultado;
  }

  //Deletar um objeto Pessoa do banco de dados

  Future<int> deletePessoa(int id) async {
    var db = await this.database;

    int resultado =
        await db.delete(pessoaTable, where: '$colId = ?', whereArgs: [id]);

    return resultado;
  }

  //
}
