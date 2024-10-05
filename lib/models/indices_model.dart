class Indices {
  String ipcaOffline;
  String selicOffline;
  String cdiOffline;
  String ipca12MesesOffline;
  String dataDosIndicesOffline;

  Indices({
    required this.ipcaOffline,
    required this.selicOffline,
    required this.cdiOffline,
    required this.ipca12MesesOffline,
    required this.dataDosIndicesOffline,
  });

  Map<String, dynamic> toMap() {
    return {
      'ipcaOffline': ipcaOffline,
      'selicOffline': selicOffline,
      'cdiOffline': cdiOffline,
      'ipca12MesesOffline': ipca12MesesOffline,
      'dataDosIndicesOffline': dataDosIndicesOffline,
    };
  }

  factory Indices.fromMap(Map<String, dynamic> map) {
    return Indices(
      ipcaOffline: map['ipcaOffline'],
      selicOffline: map['selicOffline'],
      cdiOffline: map['cdiOffline'],
      ipca12MesesOffline: map['ipca12MesesOffline'],
      dataDosIndicesOffline: map['dataDosIndicesOffline'],
    );
  }
}
