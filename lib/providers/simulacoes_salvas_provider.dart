import 'package:flutter/material.dart';

import '../helpers/database_helper.dart';
import '../models/tabelas_salvas_model.dart';

class TabelaProvider with ChangeNotifier {
  List<Tabela> _tabelas = [];

  List<Tabela> get tabelas => _tabelas;

  void addTabela(Tabela tabela) {
    _tabelas.add(tabela);
    notifyListeners();
  }

  void removeTabela(Tabela tabela) {
    _tabelas.remove(tabela);
    notifyListeners();
  }

  Future<void> loadTabelas() async {
    var dbService = DatabaseService();
    _tabelas = await dbService.getTabelas();
    notifyListeners();
  }
}
