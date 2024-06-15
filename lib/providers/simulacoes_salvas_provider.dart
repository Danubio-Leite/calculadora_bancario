import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/tabelas_salvas_model.dart';

class TabelaProvider with ChangeNotifier {
  List<Tabela> _tabelas = [];

  List<Tabela> get tabelas => _tabelas;

  TabelaProvider() {
    loadTabelas();
  }

  void addTabela(Tabela tabela) async {
    var dbService = DatabaseService.instance;
    await dbService.saveTabela(tabela);
    _tabelas.add(tabela);
    notifyListeners();
  }

  void removeTabela(Tabela tabela) async {
    var dbService = DatabaseService.instance;
    await dbService.remove(tabela.id!);
    _tabelas.remove(tabela);
    notifyListeners();
  }

  Future<void> loadTabelas() async {
    var dbService = DatabaseService.instance;
    _tabelas = await dbService.getTabelas();
    notifyListeners();
  }
}
