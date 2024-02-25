import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../providers/simulacoes_salvas_provider.dart';
import '../components/custom_calc_button.dart';
import '../helpers/database_helper.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../components/custom_calc_button.dart';
import 'package:path_provider/path_provider.dart';
import '../../helpers/database_helper.dart';
import '../../models/tabelas_salvas_model.dart';
import '../../providers/simulacoes_salvas_provider.dart';

class TelaSimulacoesSalvas extends StatefulWidget {
  const TelaSimulacoesSalvas({super.key});

  @override
  State<TelaSimulacoesSalvas> createState() => _TelaSimulacoesSalvasState();
}

class _TelaSimulacoesSalvasState extends State<TelaSimulacoesSalvas> {
  List<GlobalKey> _globalKeys = [];
  @override
  void initState() {
    super.initState();
    // Carrega as tabelas salvas do banco de dados
    Provider.of<TabelaProvider>(context, listen: false).loadTabelas();
  }

  @override
  Widget build(BuildContext context) {
    var tabelasSalvas = Provider.of<TabelaProvider>(context).tabelas;
    _globalKeys =
        List<GlobalKey>.generate(tabelasSalvas.length, (index) => GlobalKey());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minhas Simulações',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
          overflow: TextOverflow.fade,
        ),
      ),
      body: tabelasSalvas.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Nenhuma simulação salva'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: tabelasSalvas.length,
              itemBuilder: (context, index) {
                var tabela = tabelasSalvas[index];
                Uint8List imageBytes = base64Decode(tabela.imagem);

                return Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(tabela.label,
                        style: const TextStyle(fontSize: 20)),
                  ),
                  RepaintBoundary(
                      key: _globalKeys[index], child: Image.memory(imageBytes)),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 32.0, left: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomCalcButton(
                            onPressed: () async {
                              RenderRepaintBoundary boundary =
                                  _globalKeys[index]
                                          .currentContext!
                                          .findRenderObject()
                                      as RenderRepaintBoundary;
                              ui.Image image = await boundary.toImage();
                              ByteData? byteData = await image.toByteData(
                                  format: ui.ImageByteFormat.png);
                              Uint8List pngBytes =
                                  byteData!.buffer.asUint8List();

                              final tempDir = await getTemporaryDirectory();
                              final file =
                                  await File('${tempDir.path}/image.png')
                                      .create();
                              await file.writeAsBytes(pngBytes);

                              await Share.shareXFiles([XFile(file.path)]);
                            },
                            texto: 'Compartilhar',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: CustomCalcButton(
                            onPressed: () {
                              DatabaseService().remove(tabela.id);
                              Provider.of<TabelaProvider>(context,
                                      listen: false)
                                  .loadTabelas();
                              setState(() {});
                            },
                            texto: 'Excluir',
                          ),
                        ),
                      ],
                    ),
                  ),
                ]);
              },
            ),
    );
  }
}
