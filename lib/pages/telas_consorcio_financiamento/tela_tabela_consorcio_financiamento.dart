import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../components/custom_calc_button.dart';

class TabelaConsorcioFinanciamento extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  final double valorCartaCredito;
  final double valorFinanciado;
  final int prazoConsorcio;
  final int prazoFinanciamento;
  final double taxaMensalConsorcio;
  final double taxaMensalfinanciamento;
  final double parcelaConsorcio;
  final double parcelaFinanciamento;
  final double custoTotalConsorcio;
  final double custoTotalFinanciamento;
  final double valorLance;
  final double valorEntrada;
  final double totalPagoConsorcio;
  final double totalPagoFinanciamento;

  TabelaConsorcioFinanciamento({
    Key? key,
    required this.valorCartaCredito,
    required this.valorFinanciado,
    required this.prazoConsorcio,
    required this.prazoFinanciamento,
    required this.taxaMensalConsorcio,
    required this.taxaMensalfinanciamento,
    required this.parcelaConsorcio,
    required this.parcelaFinanciamento,
    required this.custoTotalConsorcio,
    required this.custoTotalFinanciamento,
    required this.valorLance,
    required this.valorEntrada,
    required this.totalPagoConsorcio,
    required this.totalPagoFinanciamento,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Financiamento | Consórcio',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
          overflow: TextOverflow.fade,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 36,
                  ),
                  RepaintBoundary(
                    key: _globalKey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.grey,
                          cardColor: Colors.white,
                        ),
                        child: FittedBox(
                          child: DataTable(
                            columnSpacing: constraints.maxWidth / 50,
                            headingRowColor:
                                MaterialStateProperty.all(Colors.grey[200]),
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(''),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Text(
                                  'Consórcio',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ),
                              DataColumn(
                                label: Expanded(
                                    child: Text('Financiamento',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))),
                              ),
                            ],
                            rows: <DataRow>[
                              _buildDataRow(
                                  'Valor',
                                  formatador.format(valorCartaCredito),
                                  formatador.format(valorFinanciado)),
                              _buildDataRow(
                                  'Lance/Entrada',
                                  formatador.format(valorLance),
                                  formatador.format(valorEntrada)),
                              _buildDataRow('Prazo', '$prazoConsorcio meses',
                                  '$prazoFinanciamento meses'),
                              _buildDataRow(
                                  'Taxa Mensal',
                                  '${taxaMensalConsorcio.toStringAsFixed(2)}%',
                                  '${taxaMensalfinanciamento.toStringAsFixed(2)}%'),
                              _buildDataRow(
                                  'Parcela',
                                  formatador.format(parcelaConsorcio),
                                  formatador.format(parcelaFinanciamento)),
                              _buildDataRow(
                                  'Total Pago',
                                  formatador.format(totalPagoConsorcio),
                                  formatador.format(totalPagoFinanciamento)),
                              _buildDataRow(
                                  'Custo Total',
                                  formatador.format(custoTotalConsorcio),
                                  formatador.format(custoTotalFinanciamento))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            '・Parcela após contemplação.\n・Informe ao cliente que a parcela, custo total e total pago desconsideram eventuais correções. Consulte as regras do produto na sua instituição',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomCalcButton(
                    onPressed: () async {
                      RenderRepaintBoundary boundary =
                          _globalKey.currentContext!.findRenderObject()
                              as RenderRepaintBoundary;
                      ui.Image image = await boundary.toImage();
                      ByteData? byteData = await image.toByteData(
                          format: ui.ImageByteFormat.png);
                      Uint8List pngBytes = byteData!.buffer.asUint8List();

                      final tempDir = await getTemporaryDirectory();
                      final file =
                          await File('${tempDir.path}/image.png').create();
                      await file.writeAsBytes(pngBytes);

                      await Share.shareXFiles([XFile(file.path)]);
                    },
                    texto: 'Compartilhar',
                  ),
                  const SizedBox(
                    height: 140,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  DataRow _buildDataRow(
      String title, String consorcioValue, String financiamentoValue) {
    return DataRow(
      cells: <DataCell>[
        _buildDataCell(title),
        _buildDataCell(consorcioValue),
        _buildDataCell(financiamentoValue),
      ],
    );
  }

  DataCell _buildDataCell(String value) {
    return DataCell(
      ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 30),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
