import 'package:flutter/material.dart';
import '../helpers/oferta_db_helper.dart';
import '../models/oferta_model.dart';

class OfertaProvider with ChangeNotifier {
  List<Oferta> _ofertas = [];

  List<Oferta> get ofertas => _ofertas;

  Future<void> loadOfertas() async {
    final ofertasFromDB = await DBHelper().getOfertas();
    _ofertas = ofertasFromDB;
    notifyListeners();
  }

  Future<void> addOferta(Oferta oferta) async {
    await DBHelper().insertOferta(oferta);
    _ofertas.add(oferta);
    notifyListeners();
  }

  Future<void> updateOferta(Oferta oferta) async {
    await DBHelper().updateOferta(oferta);
    final index = _ofertas.indexWhere((o) => o.id == oferta.id);
    if (index != -1) {
      _ofertas[index] = oferta;
      notifyListeners();
    }
  }

  Future<void> deleteOferta(int id) async {
    await DBHelper().deleteOferta(id);
    _ofertas.removeWhere((oferta) => oferta.id == id);
    notifyListeners();
  }
}
