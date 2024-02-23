import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../components/custom_calc_button.dart';
import 'package:path_provider/path_provider.dart';

class TelaTabelaComparadorInvestimentos extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  String nomeInvestimento01;
  String nomeInvestimento02;
  final double aplicacaoInicial01;
  final double aplicacaoInicial02;
  final double aplicacaoMensal01;
  final double aplicacaoMensal02;
  final double rentabilidadeInvestimento01;
  final double rentabilidadeInvestimento02;
  double montante12Meses01 = 0;
  double montante12Meses02 = 0;
  double montante02Anos01 = 0;
  double montante02Anos02 = 0;
  double montante05Anos01 = 0;
  double montante05Anos02 = 0;
  double montante10Anos01 = 0;
  double montante10Anos02 = 0;
  double montante20Anos01 = 0;
  double montante20Anos02 = 0;
  double montante30Anos01 = 0;
  double montante30Anos02 = 0;

  TelaTabelaComparadorInvestimentos({
    Key? key,
    required this.nomeInvestimento01,
    required this.nomeInvestimento02,
    required this.aplicacaoInicial01,
    required this.aplicacaoInicial02,
    required this.aplicacaoMensal01,
    required this.aplicacaoMensal02,
    required this.rentabilidadeInvestimento01,
    required this.rentabilidadeInvestimento02,
    this.montante12Meses01 = 0,
    this.montante12Meses02 = 0,
    this.montante02Anos01 = 0,
    this.montante02Anos02 = 0,
    this.montante05Anos01 = 0,
    this.montante05Anos02 = 0,
    this.montante10Anos01 = 0,
    this.montante10Anos02 = 0,
    this.montante20Anos01 = 0,
    this.montante20Anos02 = 0,
    this.montante30Anos01 = 0,
    this.montante30Anos02 = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparador de Investimentos'),
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
                    child: FittedBox(
                      child: DataTable(
                        columnSpacing: 15,
                        headingRowColor:
                            MaterialStateProperty.all(Colors.grey[200]),
                        columns: <DataColumn>[
                          const DataColumn(
                            label: Text(''),
                          ),
                          DataColumn(
                            label: Expanded(
                                child: Text(
                              nomeInvestimento01,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                nomeInvestimento02,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                        rows: <DataRow>[
                          _buildDataRow(
                              'Aplicação Inicial',
                              formatador.format(aplicacaoInicial01),
                              formatador.format(aplicacaoInicial02)),
                          _buildDataRow(
                              'Aportes Mensais',
                              formatador.format(aplicacaoMensal01),
                              formatador.format(aplicacaoMensal02)),
                          _buildDataRow(
                              'Rentabilidade a.a.',
                              '${rentabilidadeInvestimento01.toStringAsFixed(2)}%',
                              '${rentabilidadeInvestimento02.toStringAsFixed(2)}%'),
                          _buildDataRow(
                              'Montante 12 meses',
                              formatador.format(montante12Meses01),
                              formatador.format(montante12Meses02)),
                          _buildDataRow(
                              'Montante 02 anos',
                              formatador.format(montante02Anos01),
                              formatador.format(montante02Anos02)),
                          _buildDataRow(
                              'Montante 05 anos',
                              formatador.format(montante05Anos01),
                              formatador.format(montante05Anos02)),
                          _buildDataRow(
                              'Montante 10 anos',
                              formatador.format(montante10Anos01),
                              formatador.format(montante10Anos02)),
                          _buildDataRow(
                              'Montante 20 anos',
                              formatador.format(montante20Anos01),
                              formatador.format(montante20Anos02)),
                          _buildDataRow(
                              'Montante 30 anos',
                              formatador.format(montante30Anos01),
                              formatador.format(montante30Anos02)),
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
                        '・Informe ao cliente que a rentabilidade obtida no passado não representa garantia de resultados futuros. Consulte as regras dos produtos na sua instituição',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
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
              const SizedBox(
                height: 140,
              )
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
