import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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
    // buscarIPCA();
    // buscarSelic();
  }

  Future buscarIPCA() async {
    try {
      ipcaData = await ipcaHelper.buscarIPCA();
      setState(() {
        ipcaSum = ipcaHelper.calcularIPCA(ipcaData);
      });
    } catch (e) {
      print('Erro ao buscar IPCA: $e');
    }
  }

  Future buscarSelic() async {
    try {
      selic = await selicHelper.buscarSelic();
      setState(() {});
    } catch (e) {
      print('Erro ao buscar Selic: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait<void>([buscarIPCA(), buscarSelic()]),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const AlertDialog(
        //     content: Row(
        //       children: [
        //         CircularProgressIndicator(),
        //         SizedBox(width: 20),
        //         Text('Carregando dados...'),
        //       ],
        //     ),
        //   );
        // } else
        {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Índices Econômicos'),
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
                      itemCount: 4, // Apenas dois itens: o último mês e a soma
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return ipcaData.isNotEmpty
                              ? ListTile(
                                  title: Text(
                                      'IPCA ${capitalize(DateFormat('MMMM/yyyy', 'pt_BR').format(DateTime.parse(ipcaData.last['VALDATA'])))}:'),
                                  subtitle:
                                      Text('${ipcaData.last['VALVALOR']}%'),
                                )
                              : Container(); // Retorna um Container vazio se ipcaData estiver vazio
                        } else if (index == 1) {
                          return ListTile(
                            title: const Text(
                                'IPCA acumulado dos últimos 12 meses:'),
                            subtitle: Text('${ipcaSum.toStringAsFixed(2)}%'),
                          );
                        } else if (index == 2) {
                          return ListTile(
                            title: const Text('Selic:'),
                            subtitle:
                                Text('${(selic + 0.1).toStringAsFixed(2)}%'),
                          );
                        } else {
                          return ListTile(
                            title: const Text('CDI:'),
                            subtitle: Text('${selic.toStringAsFixed(2)}%'),
                          );
                        }
                      },
                    ),
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
      },
    );
  }
}
