import 'package:calculadora_bancario/models/indices_model.dart';
import 'package:flutter/material.dart';

class IndicesProvider with ChangeNotifier {
  List<Indices> _indices = [];

  List<Indices> get indices => _indices;

  void addIndices(Indices indices) {
    _indices.add(indices);
    notifyListeners();
  }

  void clearIndices() {
    _indices.clear();
    notifyListeners();
  }
}
