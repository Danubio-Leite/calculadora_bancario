import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/custom_calc_button.dart';

class TelaTabelaConsorcioInvestimento extends StatelessWidget {
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  final double valorInvestimento;
  final int prazoConsorcio;
  final int prazoInvestimento;
  final double rendimentoMensalConsorcio;
  final double rendimentoMensalInvestimento;
  final double valorCartaCredito;

  TelaTabelaConsorcioInvestimento({
    Key? key,
    required this.valorInvestimento,
    required this.prazoConsorcio,
    required this.prazoInvestimento,
    required this.rendimentoMensalConsorcio,
    required this.rendimentoMensalInvestimento,
    required this.valorCartaCredito,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consórcio x Investimento'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(''),
                  ),
                  DataColumn(
                    label: Text('Consórcio'),
                  ),
                  DataColumn(
                    label: Text('Investimento'),
                  ),
                ],
                rows: <DataRow>[
                  _buildDataRow('Valor', formatador.format(valorCartaCredito),
                      formatador.format(valorInvestimento)),
                  _buildDataRow('Prazo', '$prazoConsorcio meses',
                      '$prazoInvestimento meses'),
                  _buildDataRow(
                      'Rendimento Mensal',
                      '${rendimentoMensalConsorcio.toStringAsFixed(2)}%',
                      '${rendimentoMensalInvestimento.toStringAsFixed(2)}%'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(
      String title, String consorcioValue, String investimentoValue) {
    return DataRow(
      cells: <DataCell>[
        _buildDataCell(title),
        _buildDataCell(consorcioValue),
        _buildDataCell(investimentoValue),
      ],
    );
  }

  DataCell _buildDataCell(String value) {
    return DataCell(
      Text(value),
    );
  }
}
