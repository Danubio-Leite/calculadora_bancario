import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../components/custom_calc_button.dart';
import '../../components/insert_field.dart';
import 'dart:math' as math;

import 'tela_tabela_consorcio_financiamento.dart';

class TelaFinanciamentoXConsorcio extends StatefulWidget {
  @override
  _TelaFinanciamentoXConsorcioState createState() =>
      _TelaFinanciamentoXConsorcioState();
}

class _TelaFinanciamentoXConsorcioState
    extends State<TelaFinanciamentoXConsorcio> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'a.m.';
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  final valorBemFinanciamentoController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final parcelaFinanciamentoController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final taxaJurosController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final valorCartaCreditoController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final parcelaConsorcioController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final taxaAdministracaoController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final lanceConsorcioController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final entradaController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final prazoConsorcioController = TextEditingController();
  final prazoFinanciamentoController = TextEditingController();

  double valorBemFinanciamento = 0.0;
  int prazoFinanciamento = 0;
  double parcelaFinanciamento = 0.0;
  double taxaJuros = 0.0;
  double valorCartaCredito = 0.0;
  int prazoConsorcio = 0;
  double parcelaConsorcio = 0.0;
  double taxaAdministracao = 0.0;
  double taxaMensalConsorcio = 0.0;
  double taxaMensalfinanciamento = 0.0;
  double custoTotalFinanciamento = 0.0;
  double custoTotalConsorcio = 0.0;
  double lanceConsorcio = 0.0;
  double entrada = 0.0;

  @override
  void dispose() {
    // Limppeza dos controllers quando o widget for descartado
    valorBemFinanciamentoController.dispose();
    prazoFinanciamentoController.dispose();
    parcelaFinanciamentoController.dispose();
    taxaJurosController.dispose();
    valorCartaCreditoController.dispose();
    prazoConsorcioController.dispose();
    parcelaConsorcioController.dispose();
    taxaAdministracaoController.dispose();
    lanceConsorcioController.dispose();
    entradaController.dispose();

    super.dispose();
  }

  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, preencha este campo';
    }
    return null;
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                      'Sobre o Comparador de Financiamento e Consórcio'),
                  content: const SingleChildScrollView(
                    child: Text(
                        'Esta calculadora permite que você compare o custo total de um financiamento e de um consórcio, considerando o valor financiado, o prazo e a taxa de juros para o financiamento, e o valor da carta de crédito, o prazo e a taxa de administração para o consórcio.\n\nOs valores apresentados são aproximados e não levam em consideração impostos ou correções nos valores das parcelas.'),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('OK',
                          style: TextStyle(color: Colors.black)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text('Financiamento:', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 6),
                CustomInsertField(
                  controller: valorBemFinanciamentoController,
                  label: 'Valor do bem',
                  prefix: const Text('R\$ '),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: validateInput,
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: entradaController,
                  label: 'Entrada',
                  keyboardType: TextInputType.number,
                  prefix: const Text('R\$ '),
                  validator: validateInput,
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: prazoFinanciamentoController,
                  label: 'Prazo',
                  keyboardType: TextInputType.number,
                  suffix: const Text('meses'),
                  validator: validateInput,
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: parcelaFinanciamentoController,
                  label: 'Parcela (Price)',
                  prefix: const Text('R\$ '),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: validateInput,
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomInsertField(
                        controller: taxaJurosController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        suffix: const Text('%'),
                        label: 'Taxa de juros',
                        validator: validateInput,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['a.m.', 'a.a.']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        underline: const SizedBox(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Consórcio:', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 6),
                CustomInsertField(
                  controller: valorCartaCreditoController,
                  label: 'Valor da carta de crédito',
                  prefix: const Text('R\$ '),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: validateInput,
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: lanceConsorcioController,
                  label: 'Valor do lance',
                  keyboardType: TextInputType.number,
                  prefix: const Text('R\$ '),
                  validator: validateInput,
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: prazoConsorcioController,
                  label: 'Prazo após contemplação',
                  keyboardType: TextInputType.number,
                  suffix: const Text('meses'),
                  validator: validateInput,
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: parcelaConsorcioController,
                  label: 'Parcela após contemplação',
                  prefix: const Text('R\$ '),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: validateInput,
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: taxaAdministracaoController,
                  label: 'Taxa de administração total',
                  suffix: const Text('%'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: validateInput,
                ),
                const SizedBox(height: 16),
                CustomCalcButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                    color:
                                        const Color.fromARGB(255, 0, 96, 164),
                                    size: 60,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Configurando Tabela",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 96, 164),
                                    ),
                                  ), // O texto
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      Future.delayed(const Duration(milliseconds: 1500), () {
                        Navigator.of(context).pop();

                        setState(() {
                          valorBemFinanciamento =
                              valorBemFinanciamentoController.numberValue;
                          prazoFinanciamento =
                              int.tryParse(prazoFinanciamentoController.text) ??
                                  0;
                          parcelaFinanciamento =
                              parcelaFinanciamentoController.numberValue;
                          taxaJuros = taxaJurosController.numberValue;
                          valorCartaCredito =
                              valorCartaCreditoController.numberValue;
                          prazoConsorcio =
                              int.tryParse(prazoConsorcioController.text) ?? 0;
                          parcelaConsorcio =
                              parcelaConsorcioController.numberValue;
                          lanceConsorcio = lanceConsorcioController.numberValue;
                          taxaAdministracao =
                              taxaAdministracaoController.numberValue;
                          entrada = entradaController.numberValue;
                          taxaMensalConsorcio =
                              taxaAdministracao / prazoConsorcio;
                          if (dropdownValue == 'a.m.') {
                            taxaMensalfinanciamento = taxaJuros;
                          } else {
                            taxaMensalfinanciamento = taxaJuros / 12;
                          }

                          double totalPagoConsorcio =
                              parcelaConsorcio * prazoConsorcio +
                                  lanceConsorcio;
                          double totalPagoFinanciamento =
                              parcelaFinanciamento * prazoFinanciamento +
                                  entrada;

                          custoTotalFinanciamento =
                              totalPagoFinanciamento - valorBemFinanciamento;
                          custoTotalConsorcio =
                              totalPagoConsorcio - valorCartaCredito;

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  TabelaConsorcioFinanciamento(
                                valorCartaCredito: valorCartaCredito,
                                valorFinanciado: valorBemFinanciamento,
                                prazoConsorcio: prazoConsorcio,
                                prazoFinanciamento: prazoFinanciamento,
                                taxaMensalConsorcio: taxaMensalConsorcio,
                                taxaMensalfinanciamento:
                                    taxaMensalfinanciamento,
                                parcelaConsorcio: parcelaConsorcio,
                                parcelaFinanciamento: parcelaFinanciamento,
                                custoTotalConsorcio: custoTotalConsorcio,
                                custoTotalFinanciamento:
                                    custoTotalFinanciamento,
                                valorLance: lanceConsorcio,
                                valorEntrada: entrada,
                                totalPagoConsorcio: totalPagoConsorcio,
                                totalPagoFinanciamento: totalPagoFinanciamento,
                              ),
                            ),
                          );
                        });
                      });
                    }
                  },
                  texto: 'Gerar Tabela',
                ),
                const SizedBox(
                  height: 140,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
