import 'package:flutter/material.dart';
import '../components/custom_calc_button.dart';
import '../components/insert_field.dart';
import 'dart:math' as math;

import 'tela_tabela_consorcio.dart';

class TelaFinanciamentoXConsorcio extends StatefulWidget {
  @override
  _TelaFinanciamentoXConsorcioState createState() =>
      _TelaFinanciamentoXConsorcioState();
}

class _TelaFinanciamentoXConsorcioState
    extends State<TelaFinanciamentoXConsorcio> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'a.m.';

  final valorFinanciadoController = TextEditingController();
  final prazoFinanciamentoController = TextEditingController();
  final parcelaFinanciamentoController = TextEditingController();
  final taxaJurosController = TextEditingController();
  final valorCartaCreditoController = TextEditingController();
  final prazoConsorcioController = TextEditingController();
  final parcelaConsorcioController = TextEditingController();
  final taxaAdministracaoController = TextEditingController();
  final lanceConsorcioController = TextEditingController();

  double valorFinanciado = 0.0;
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

  @override
  void dispose() {
    // Limppeza dos controllers quando o widget for descartado
    valorFinanciadoController.dispose();
    prazoFinanciamentoController.dispose();
    parcelaFinanciamentoController.dispose();
    taxaJurosController.dispose();
    valorCartaCreditoController.dispose();
    prazoConsorcioController.dispose();
    parcelaConsorcioController.dispose();
    taxaAdministracaoController.dispose();
    lanceConsorcioController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financiamento X Consórcio'),
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
                  controller: valorFinanciadoController,
                  label: 'Valor financiado',
                  prefix: const Text('R\$ '),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: prazoFinanciamentoController,
                  label: 'Prazo',
                  keyboardType: TextInputType.number,
                  suffix: const Text('meses'),
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: parcelaFinanciamentoController,
                  label: 'Parcela (Price)',
                  prefix: const Text('R\$ '),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: prazoConsorcioController,
                  label: 'Prazo',
                  keyboardType: TextInputType.number,
                  suffix: const Text('meses'),
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: lanceConsorcioController,
                  label: 'Valor do lance',
                  keyboardType: TextInputType.number,
                  prefix: const Text('R\$ '),
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: parcelaConsorcioController,
                  label: 'Parcela após contemplação',
                  prefix: const Text('R\$ '),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: taxaAdministracaoController,
                  label: 'Taxa de administração total',
                  suffix: const Text('%'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                CustomCalcButton(
                  onPressed: () {
                    setState(() {
                      valorFinanciado =
                          double.tryParse(valorFinanciadoController.text) ??
                              0.0;
                      prazoFinanciamento =
                          int.tryParse(prazoFinanciamentoController.text) ?? 0;
                      parcelaFinanciamento = double.tryParse(
                              parcelaFinanciamentoController.text) ??
                          0.0;
                      taxaJuros =
                          double.tryParse(taxaJurosController.text) ?? 0.0;
                      valorCartaCredito =
                          double.tryParse(valorCartaCreditoController.text) ??
                              0.0;
                      prazoConsorcio =
                          int.tryParse(prazoConsorcioController.text) ?? 0;
                      parcelaConsorcio =
                          double.tryParse(parcelaConsorcioController.text) ??
                              0.0;
                      taxaAdministracao =
                          double.tryParse(taxaAdministracaoController.text) ??
                              0.0;
                      taxaMensalConsorcio = taxaAdministracao / prazoConsorcio;
                      if (dropdownValue == 'a.m.') {
                        taxaMensalfinanciamento = taxaJuros;
                      } else {
                        taxaMensalfinanciamento = taxaJuros / 12;
                      }
                      custoTotalFinanciamento =
                          parcelaFinanciamento * prazoFinanciamento -
                              valorFinanciado;
                      custoTotalConsorcio =
                          parcelaConsorcio * prazoConsorcio - valorCartaCredito;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TabelaConsorcioFinanciamento(
                            valorCartaCredito: valorCartaCredito,
                            valorFinanciado: valorFinanciado,
                            prazoConsorcio: prazoConsorcio,
                            prazoFinanciamento: prazoFinanciamento,
                            taxaMensalConsorcio: taxaMensalConsorcio,
                            taxaMensalfinanciamento: taxaMensalfinanciamento,
                            parcelaConsorcio: parcelaConsorcio,
                            parcelaFinanciamento: parcelaFinanciamento,
                            custoTotalConsorcio: custoTotalConsorcio,
                            custoTotalFinanciamento: custoTotalFinanciamento,
                          ),
                        ),
                      );
                    });
                  },
                  texto: 'Gerar comparação',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
