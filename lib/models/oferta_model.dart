class Oferta {
  int? id;
  String label;
  String texto;
  String data;
  String produto;

  Oferta({
    this.id,
    required this.label,
    required this.texto,
    required this.data,
    required this.produto,
  });

  // Método para converter oferta em Map para o banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'texto': texto,
      'data': data,
      'produto': produto,
    };
  }

  // Método para converter Map do banco de dados em oferta
  factory Oferta.fromMap(Map<String, dynamic> map) {
    return Oferta(
      id: map['id'],
      label: map['label'],
      texto: map['texto'],
      data: map['data'],
      produto: map['produto'],
    );
  }
}
