import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart'; // Importa a biblioteca intl para formatar a data
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../components/custom_calc_button.dart';
import '../../components/insert_field.dart';
import '../../utils/calc_utils.dart';
import 'tela_tabela_price_sac.dart';

class TelaPriceSac extends StatefulWidget {
  @override
  _TelaPriceSacState createState() => _TelaPriceSacState();
}

class _TelaPriceSacState extends State<TelaPriceSac> {
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final valorEmprestimoController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final valorSegurosETaxasController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final taxaJurosController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final prazoMesesController = TextEditingController();
  String _tipoDeTaxaSelecionada = 'a.m.';

  final _formKey = GlobalKey<FormState>(); // Adicionado

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
        title: const Text('Comparador Sac x Price'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sobre o Comparador SAC x Price'),
                  content: const SingleChildScrollView(
                    child: Text(
                        'Esta calculadora permite que você calcule os valores de parcela e custo total de um financiamento utilizando os sistemas de amortização SAC e PRICE.\n\n Os valores apresentados são aproximados e podem variar de acordo com a instituição financeira e o contrato de financiamento.'),
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
              children: [
                CustomInsertField(
                  controller: valorEmprestimoController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  label: 'Valor Financiado',
                  prefix: const Text('R\$ '),
                  validator: validateInput,
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: valorSegurosETaxasController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  label: 'Seguros e Taxas (Se financiados)',
                  prefix: const Text('R\$ '),
                  validator: validateInput,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomInsertField(
                        controller: taxaJurosController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        label: 'Taxa de Juros',
                        suffix: const Text('%'),
                        validator: validateInput,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        value: _tipoDeTaxaSelecionada,
                        items: <String>['a.m.', 'a.a.'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _tipoDeTaxaSelecionada = newValue!;
                          });
                        },
                        underline:
                            const SizedBox(), // remove the default underline
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: prazoMesesController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  label: 'Prazo (em meses)',
                  validator: validateInput,
                ),
                const SizedBox(height: 24),
                CustomCalcButton(
                  texto: 'Calcular',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      double valorEmprestimo =
                          valorEmprestimoController.numberValue;
                      double valorSegurosETaxas =
                          valorSegurosETaxasController.numberValue;
                      double taxaJuros = taxaJurosController.numberValue;
                      int prazoMeses =
                          int.tryParse(prazoMesesController.text) ?? 0;

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

                        // O restante do seu código
                        final valorParcelaPrice = CalculadoraPriceSimples()
                            .calcularParcelaPrice(valorEmprestimo, taxaJuros,
                                prazoMeses, _tipoDeTaxaSelecionada);
                        final valorParcelaSAC = CalculadoraSAC()
                            .calculaFinanciamentoSAC(
                                valorEmprestimo + valorSegurosETaxas,
                                prazoMeses,
                                taxaJuros,
                                _tipoDeTaxaSelecionada);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaTabelaPriceSac(
                              valorFinanciado:
                                  valorEmprestimo + valorSegurosETaxas,
                              taxaJuros: taxaJuros,
                              prazoFinanciamento: prazoMeses,
                              tipoDeTaxa: _tipoDeTaxaSelecionada,
                              valorParcelaInicialPrice: valorParcelaPrice,
                              valorParcelaInicialSAC: valorParcelaSAC[0],
                              valorParcelaFinalPrice: valorParcelaPrice,
                              valorParcelaFinalSAC:
                                  valorParcelaSAC[prazoMeses - 1],
                              valorTotalPagoPrice:
                                  valorParcelaPrice * prazoMeses,
                              valorTotalJurosPrice:
                                  (valorParcelaPrice * prazoMeses) -
                                      (valorEmprestimo + valorSegurosETaxas),
                              valorTotalPagoSAC: valorParcelaSAC.reduce(
                                  (valorAtual, elemento) =>
                                      valorAtual + elemento),
                              valorTotalJurosSAC: valorParcelaSAC.reduce(
                                      (valorAtual, elemento) =>
                                          valorAtual + elemento) -
                                  (valorEmprestimo + valorSegurosETaxas),
                            ),
                          ),
                        );
                      });
                    }
                  },
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
