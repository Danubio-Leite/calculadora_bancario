import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import '../../components/custom_calc_button.dart';
import '../../providers/simulacoes_salvas_provider.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class SimulacoesDetalhes extends StatefulWidget {
  var tabela;
  var index;
  SimulacoesDetalhes({super.key, this.tabela, this.index});

  @override
  State<SimulacoesDetalhes> createState() => _SimulacoesDetalhesState();
}

class _SimulacoesDetalhesState extends State<SimulacoesDetalhes> {
  Uint8List? imageBytes;
  GlobalKey _globalKey = GlobalKey();
  void initState() {
    super.initState();
    imageBytes = base64Decode(widget.tabela.imagem);
    initializeDateFormatting('pt_BR', null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalhes da Simulação',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
          overflow: TextOverflow.fade,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.tabela.label,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
            ),
            RepaintBoundary(
              key: _globalKey,
              child: Image.memory(imageBytes!),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                bottom: 32.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomCalcButton(
                      onPressed: () async {
                        Provider.of<TabelaProvider>(context, listen: false)
                            .removeTabela(widget.tabela);
                        Navigator.pop(context);
                      },
                      texto: 'Excluir',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: CustomCalcButton(
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
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
