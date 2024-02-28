import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import '../../../providers/simulacoes_salvas_provider.dart';
import 'package:intl/intl.dart';

import '../../components/minhas_simulacoes_button.dart';
import '../../helpers/database_helper.dart';
import '../../models/tabelas_salvas_model.dart';
import 'tela_detalhes_simulacoes.dart';

class TelaSimulacoesSalvas extends StatefulWidget {
  const TelaSimulacoesSalvas({super.key});

  @override
  State<TelaSimulacoesSalvas> createState() => _TelaSimulacoesSalvasState();
}

class _TelaSimulacoesSalvasState extends State<TelaSimulacoesSalvas> {
  List<GlobalKey> _globalKeys = [];
  String _categoriaSelecionada = 'Todas';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TabelaProvider>(context, listen: false).loadTabelas();
    });
  }

  @override
  Widget build(BuildContext context) {
    var tabelasSalvas = Provider.of<TabelaProvider>(context).tabelas;
    if (_categoriaSelecionada != 'Todas') {
      tabelasSalvas = tabelasSalvas
          .where((tabela) => tabela.categoria == _categoriaSelecionada)
          .toList();
    }
    double textWidth = MediaQuery.of(context).size.width * 0.8;
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
          : Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        MinhasSimulacoesButton(
                          label: 'Todas',
                          categoriaSelecionada: _categoriaSelecionada,
                          onPressed: () {
                            setState(() {
                              _categoriaSelecionada = 'Todas';
                            });
                          },
                        ),
                        MinhasSimulacoesButton(
                          label: 'Investimentos',
                          categoriaSelecionada: _categoriaSelecionada,
                          onPressed: () {
                            setState(() {
                              _categoriaSelecionada = 'Investimentos';
                            });
                          },
                        ),
                        MinhasSimulacoesButton(
                          label: 'Sac | Price',
                          categoriaSelecionada: _categoriaSelecionada,
                          onPressed: () {
                            setState(() {
                              _categoriaSelecionada = 'Sac | Price';
                            });
                          },
                        ),
                        MinhasSimulacoesButton(
                          label: 'Financiamento | Consórcio',
                          categoriaSelecionada: _categoriaSelecionada,
                          onPressed: () {
                            setState(() {
                              _categoriaSelecionada =
                                  'Financiamento | Consórcio';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: tabelasSalvas.length,
                    itemBuilder: (context, index) {
                      var tabela = tabelasSalvas[index];
                      Uint8List imageBytes = base64Decode(tabela.imagem);

                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8.0, right: 8.0),
                        child: Column(children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SimulacoesDetalhes(
                                        tabela: tabela, index: index)),
                              );
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              child: Card(
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 83, 149, 202),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4.0,
                                          right: 2.0,
                                          top: 2.0,
                                          bottom: 2.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              width: textWidth,
                                              child: Text(tabela.label,
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  style: const TextStyle(
                                                      fontSize: 20)),
                                            ),
                                          ),
                                          Text(tabela.categoria,
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                          Text(
                                              DateFormat('dd/MM/yyyy', 'pt_BR')
                                                  .format(DateTime.parse(
                                                      tabela.data)),
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
