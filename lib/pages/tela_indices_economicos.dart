import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../components/anuncio.dart';
import '../helpers/indices_helper.dart';

class TelaIndicesEconomicos extends StatefulWidget {
  const TelaIndicesEconomicos({Key? key}) : super(key: key);

  @override
  _TelaIndicesEconomicosState createState() => _TelaIndicesEconomicosState();
}

class _TelaIndicesEconomicosState extends State<TelaIndicesEconomicos> {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  List<dynamic> ipcaData = [];
  double ipcaSum = 0.0;
  IPCAHelper ipcaHelper = IPCAHelper();
  double selic = 0.0;
  SelicHelper selicHelper = SelicHelper();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    buscarDados();
  }

  Future buscarDados() async {
    try {
      ipcaData = await ipcaHelper.buscarIPCA();
      selic = await selicHelper.buscarSelic();
      setState(() {
        ipcaSum = ipcaHelper.calcularIPCA(ipcaData);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar dados: $e'),
        ),
      );
    }
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
            Text(
              capitalize(DateFormat('EEEE, dd/MM/yyyy', 'pt_BR')
                  .format(DateTime.now())),
              style: const TextStyle(fontSize: 24),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      title: Text(
                          'IPCA ${ipcaData.isNotEmpty ? capitalize(DateFormat('MMMM/yyyy', 'pt_BR').format(DateTime.parse(ipcaData.last['VALDATA']))) : ''}:'),
                      subtitle: ipcaData.isNotEmpty
                          ? Text('${ipcaData.last['VALVALOR']}%')
                          : _loading(),
                    );
                  } else if (index == 1) {
                    return ListTile(
                      title: const Text('IPCA acumulado dos últimos 12 meses:'),
                      subtitle: ipcaData.isNotEmpty
                          ? Text('${ipcaSum.toStringAsFixed(2)}%')
                          : _loading(),
                    );
                  } else if (index == 2) {
                    return ListTile(
                      title: const Text('Selic:'),
                      subtitle: selic != 0.0
                          ? Text('${(selic + 0.1).toStringAsFixed(2)}%')
                          : _loading(),
                    );
                  } else {
                    return ListTile(
                      title: const Text('CDI:'),
                      subtitle: selic != 0.0
                          ? Text('${selic.toStringAsFixed(2)}%')
                          : _loading(),
                    );
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

  _loading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        LoadingAnimationWidget.flickr(
            size: 20,
            leftDotColor: const Color.fromARGB(255, 148, 148, 149),
            rightDotColor: const Color.fromARGB(255, 146, 176, 219)),
      ],
    );
  }
}
