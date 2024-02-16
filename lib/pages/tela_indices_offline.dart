import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/anuncio.dart';
import '../helpers/database_helper.dart';
import '../models/indices_model.dart';

class TelaIndicesEconomicosOffline extends StatefulWidget {
  const TelaIndicesEconomicosOffline({Key? key}) : super(key: key);

  @override
  _TelaIndicesEconomicosOfflineState createState() =>
      _TelaIndicesEconomicosOfflineState();
}

class _TelaIndicesEconomicosOfflineState
    extends State<TelaIndicesEconomicosOffline> {
  String ipcaOffline = '0,42';
  String selicOffline = '11,25';
  String cdiOffline = '11,15';
  String ipca12MesesOffline = '4,51';
  String dataDosIndicesOffline = '15/02/2024';

  @override
  void initState() {
    super.initState();

    // Busque os dados do banco de dados SQLite
    DatabaseHelper.instance.queryAllRows().then((value) {
      if (value.isNotEmpty) {
        // Use os dados do banco de dados SQLite
        Indices indices = Indices.fromMap(value.first);
        setState(() {
          ipcaOffline = indices.ipcaOffline;
          selicOffline = indices.selicOffline;
          cdiOffline = indices.cdiOffline;
          ipca12MesesOffline = indices.ipca12MesesOffline;
          dataDosIndicesOffline = indices.dataDosIndicesOffline;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Índices Econômicos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sobre os Índices Econômicos'),
                  content: const SingleChildScrollView(
                    child: Text(
                        'Esta tela apresenta alguns índices econômicos, como o IPCA (Índice Nacional de Preços ao Consumidor Amplo), a Selic e o CDI (Certificado de Depósito Interbancário).\n\nOs dados são obtidos do Ipeadata e do Banco Central do Brasil. As informações são atualizadas mensalmente.'),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('OK',
                          style: TextStyle(color: Colors.black)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              '- Sem acesso à Internet -',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Informações de ',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                Text(
                  dataDosIndicesOffline,
                  style: const TextStyle(
                      fontSize: 24, color: Color.fromARGB(255, 176, 49, 40)),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      title: const Text('IPCA:'),
                      subtitle: Text('$ipcaOffline%'),
                    );
                  } else if (index == 1) {
                    return ListTile(
                      title: const Text('IPCA acumulado dos últimos 12 meses:'),
                      subtitle: Text(ipca12MesesOffline),
                    );
                  } else if (index == 2) {
                    return ListTile(
                      title: const Text('Selic:'),
                      subtitle: Text(selicOffline),
                    );
                  } else {
                    return ListTile(
                        title: const Text('CDI:'), subtitle: Text(cdiOffline));
                  }
                },
              ),
            ),
            const SizedBox(
              height: 72.0,
              child: MeuAnuncio(),
            ),
            const Row(
              children: [
                Text('Fonte: Ipeadata e Bacen'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
