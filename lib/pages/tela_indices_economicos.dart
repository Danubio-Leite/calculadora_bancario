import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class TelaIndicesEconomicos extends StatefulWidget {
  const TelaIndicesEconomicos({Key? key}) : super(key: key);

  @override
  _TelaIndicesEconomicosState createState() => _TelaIndicesEconomicosState();
}

class _TelaIndicesEconomicosState extends State<TelaIndicesEconomicos> {
  List<dynamic> ipcaData = [];

  @override
  void initState() {
    super.initState();
    buscarIPCA();
  }

  buscarIPCA() async {
    var url = Uri.parse(
        'http://api.bcb.gov.br/dados/serie/bcdata.sgs.433/ultimos/12?formato=json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('Dados recebidos da API:');
      print(data);
      var oneYearAgo = DateTime.now().subtract(Duration(days: 365));
      setState(() {
        ipcaData = data
            .where((item) => DateTime.parse(item['data']).isAfter(oneYearAgo))
            .toList();
      });
      print('Dados filtrados:');
      print(ipcaData);
    } else {
      throw Exception('Falha ao carregar dados do IPCA');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Índices Econômicos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              DateFormat('EEEE, dd/MM/yyyy').format(DateTime.now()),
              style: const TextStyle(fontSize: 24),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: ipcaData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(ipcaData[index]['data']))),
                    subtitle: Text(ipcaData[index]['valor'].toString()),
                  );
                },
              ),
            ),
            Row(
              children: [
                const Text('Ipeadata '),
                Text(
                  DateFormat('EEEE, dd/MM/yyyy').format(DateTime.now()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
