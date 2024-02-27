import 'dart:typed_data';

class Tabela {
  final int id;
  final String label;
  final String imagem;
  final String categoria;
  final String data;

  Tabela({
    required this.label,
    required this.imagem,
    required this.id,
    required this.categoria,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'imagem': imagem,
      'categoria': categoria,
      'data': data,
    };
  }

  // Criar um objeto Tabela a partir do mapa
  static Tabela fromMap(Map<String, dynamic> map) {
    return Tabela(
      label: map['label'] ?? '',
      imagem: map['imagem'] ?? '',
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch,
      categoria: map['categoria'] ?? '',
      data: map['data'] ?? '',
    );
  }
}
