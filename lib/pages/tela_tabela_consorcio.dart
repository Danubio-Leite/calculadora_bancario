import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../components/custom_calc_button.dart';

class TabelaConsorcioFinanciamento extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparação'),
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
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.grey,
                          cardColor: Colors.white,
                        ),
                        child: DataTable(
                          columnSpacing: constraints.maxWidth / 50,
                          headingRowColor:
                              MaterialStateProperty.all(Colors.grey[200]),
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(''),
                            ),
                            DataColumn(
                              label: Text('Consórcio'),
                            ),
                            DataColumn(
                              label: Text('Financiamento'),
                            ),
                          ],
                          rows: <DataRow>[
                            _buildDataRow(
                                'Valor',
                                'R\$ ${valorCartaCredito.toStringAsFixed(2)}',
                                'R\$ ${valorFinanciado.toStringAsFixed(2)}'),
                            _buildDataRow('Prazo', '$prazoConsorcio meses',
                                '$prazoFinanciamento meses'),
                            _buildDataRow(
                                'Taxa Mensal',
                                '${taxaMensalConsorcio.toStringAsFixed(2)}%',
                                '${taxaMensalfinanciamento.toStringAsFixed(2)}%'),
                            _buildDataRow(
                                'Parcela',
                                'R\$ ${parcelaConsorcio.toStringAsFixed(2)}',
                                'R\$ ${parcelaFinanciamento.toStringAsFixed(2)}'),
                            _buildDataRow(
                                'Custo Total',
                                'R\$ ${custoTotalConsorcio.toStringAsFixed(2)}',
                                'R\$ ${custoTotalFinanciamento.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    ),
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