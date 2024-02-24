import 'dart:typed_data';

class Tabela {
  final int id;
  final String label;
  final String imagem;
  final String caregoria;

  Tabela(
      {required this.label,
      required this.imagem,
      required this.id,
      required this.caregoria});

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      // Convertendo Uint8List para List<int> para armazenar no SQLite
      'imagem': imagem,
    };
  }

  // Método adicional para criar um objeto Tabela a partir de um mapa
  static Tabela fromMap(Map<String, dynamic> map) {
    return Tabela(
      label: map['label'],
      imagem: map['imagem'],
      id: map['id'],
      caregoria: map['caregoria'],
    );
  }
}
