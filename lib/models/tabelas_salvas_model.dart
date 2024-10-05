class Tabela {
  final int? id;
  final String label;
  final String imagem;
  final String categoria;
  final String data;

  Tabela({
    this.id,
    required this.label,
    required this.imagem,
    required this.categoria,
    required this.data,
  });

  Map<String, dynamic> toMap({bool forInsert = false}) {
    var map = <String, dynamic>{
      'label': label,
      'imagem': imagem,
      'categoria': categoria,
      'data': data,
    };
    if (!forInsert && id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Criar um objeto Tabela a partir do mapa
  static Tabela fromMap(Map<String, dynamic> map) {
    return Tabela(
      label: map['label'] ?? '',
      imagem: map['imagem'] ?? '',
      id: map['id'],
      categoria: map['categoria'] ?? '',
      data: map['data'] ?? '',
    );
  }
}
