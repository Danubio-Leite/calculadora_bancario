import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class IPCAHelper {
  Future<List<dynamic>> buscarIPCA() async {
    var url = Uri.parse(
        'http://ipeadata.gov.br/api/odata4/ValoresSerie(SERCODIGO=\'PRECOS12_IPCAG12\')');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var lastTwelveData = data['value'].sublist(data['value'].length - 12);
      return lastTwelveData;
    } else {
      throw Exception('Falha ao carregar dados do IPCA');
    }
  }

  double calcularIPCA(List<dynamic> ipcaData) {
    double ipcaSum = ipcaData.fold(1.0, (product, item) {
      return product * (1 + item['VALVALOR'] / 100);
    });
    ipcaSum = (ipcaSum - 1) *
        100; // Subtrai 1 e multiplica por 100 para obter a porcentagem
    return ipcaSum;
  }
}

class SelicHelper {
  //Aparentemente a informação apresentada é o CDI, fiz o ajuste na tela de apresentação
  Future<double> buscarSelic() async {
    var url = Uri.parse(
        'https://api.bcb.gov.br/dados/serie/bcdata.sgs.11/dados?formato=json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var lastValue =
          double.parse(data.last['valor']) / 100; // Convertendo para decimal
      int diasNoAno = 252; // Número de dias úteis em um ano

      double taxaAnual = pow(1 + lastValue, diasNoAno) - 1;
      taxaAnual = taxaAnual * 100; // Convertendo de volta para porcentagem
      return taxaAnual;
    } else {
      throw Exception('Falha ao carregar dados da Selic');
    }
  }
}
