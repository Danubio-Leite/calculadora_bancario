import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../components/custom_calc_button.dart';
import 'package:path_provider/path_provider.dart';

class TelaTabelaPriceSac extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  final double valorFinanciado;
  final double taxaJuros;
  final String tipoDeTaxa;
  final int prazoFinanciamento;
  double valorParcelaInicialPrice = 0;
  double valorParcelaFinalPrice = 0;
  double valorParcelaInicialSAC = 0;
  double valorParcelaFinalSAC = 0;
  double valorTotalPagoPrice = 0;
  double valorTotalJurosPrice = 0;
  double valorTotalPagoSAC = 0;
  double valorTotalJurosSAC = 0;

  TelaTabelaPriceSac({
    Key? key,
    required this.valorFinanciado,
    required this.taxaJuros,
    required this.tipoDeTaxa,
    required this.prazoFinanciamento,
    this.valorParcelaInicialPrice = 0,
    this.valorParcelaFinalPrice = 0,
    this.valorParcelaInicialSAC = 0,
    this.valorParcelaFinalSAC = 0,
    this.valorTotalPagoPrice = 0,
    this.valorTotalJurosPrice = 0,
    this.valorTotalPagoSAC = 0,
    this.valorTotalJurosSAC = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparador SAC x Price'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    child: DataTable(
                      columnSpacing: 30,
                      headingRowColor:
                          MaterialStateProperty.all(Colors.grey[200]),
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(''),
                        ),
                        DataColumn(
                          label: Text('Price'),
                        ),
                        DataColumn(
                          label: Text('SAC'),
                        ),
                      ],
                      rows: <DataRow>[
                        _buildDataRow(
                            'Valor Financiado',
                            formatador.format(valorFinanciado),
                            formatador.format(valorFinanciado)),
                        _buildDataRow(
                            'Taxa de Juros',
                            '${taxaJuros.toStringAsFixed(2)}% $tipoDeTaxa',
                            '${taxaJuros.toStringAsFixed(2)}% $tipoDeTaxa'),
                        _buildDataRow(
                          'Prazo',
                          prazoFinanciamento.toString(),
                          prazoFinanciamento.toString(),
                        ),
                        _buildDataRow(
                            'Parcela Inicial',
                            formatador.format(valorParcelaInicialPrice),
                            formatador.format(valorParcelaInicialSAC)),
                        _buildDataRow(
                            'Parcela Final',
                            formatador.format(valorParcelaFinalPrice),
                            formatador.format(valorParcelaFinalSAC)),
                        _buildDataRow(
                            'Total Pago',
                            formatador.format(valorTotalPagoPrice),
                            formatador.format(valorTotalPagoSAC)),
                        _buildDataRow(
                            'Total Juros',
                            formatador.format(valorTotalJurosPrice),
                            formatador.format(valorTotalJurosSAC)),
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
                  RenderRepaintBoundary boundary = _globalKey.currentContext!
                      .findRenderObject() as RenderRepaintBoundary;
                  ui.Image image = await boundary.toImage();
                  ByteData? byteData =
                      await image.toByteData(format: ui.ImageByteFormat.png);
                  Uint8List pngBytes = byteData!.buffer.asUint8List();

                  final tempDir = await getTemporaryDirectory();
                  final file = await File('${tempDir.path}/image.png').create();
                  await file.writeAsBytes(pngBytes);

                  await Share.shareXFiles([XFile(file.path)]);
                },
                texto: 'Compartilhar',
              ),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(
      String title, String investimento01Value, String investimento02Value) {
    return DataRow(
      cells: <DataCell>[
        _buildDataCell(title),
        _buildDataCell(investimento01Value),
        _buildDataCell(investimento02Value),
      ],
    );
  }

  DataCell _buildDataCell(String value) {
    return DataCell(
      ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 30,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(value),
            ),
          ],
        ),
      ),
    );
  }
}
