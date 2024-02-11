import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa a biblioteca intl para formatar a data
import '../../components/custom_calc_button.dart';
import '../../components/insert_field.dart';
import '../../components/result_card.dart';
import '../../utils/calc_utils.dart';
import 'tela_tabela_price_sac.dart';

class TelaPriceSac extends StatefulWidget {
  @override
  _TelaPriceSacState createState() => _TelaPriceSacState();
}

class _TelaPriceSacState extends State<TelaPriceSac> {
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  double valorEmprestimo = 0;
  String _tipoDeTaxaSelecionada = 'a.m.';
  double taxaJuros = 0;
  int prazoMeses = 0;
  double pagamentoMensal = 0;
  DateTime? dataPrimeiraParcela;
  double valorSegurosETaxas = 0;

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
                  title: const Text('Sobre a Calculadora de Empréstimo SAC'),
                  content: const Text(
                      'Esta calculadora permite que você calcule o valor da parcela de um empréstimo pelo sistema SAC, considerando o valor do empréstimo, seguros e taxas, a taxa de juros mensal e o prazo em meses.\n\nO valor apresentado é aproximado e pode haver variações no momento da contratação.'),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomInsertField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                label: 'Valor Financiado',
                prefix: const Text('R\$ '),
                onChanged: (value) {
                  setState(() {
                    valorEmprestimo = double.tryParse(
                            value.replaceAll('.', ',').replaceAll(',', '.')) ??
                        0;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomInsertField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                label: 'Seguros e Taxas (Se financiados)',
                prefix: const Text('R\$ '),
                onChanged: (value) {
                  setState(() {
                    valorSegurosETaxas = double.tryParse(
                            value.replaceAll('.', ',').replaceAll(',', '.')) ??
                        0;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomInsertField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      label: 'Taxa de Juros',
                      suffix: const Text('%'),
                      onChanged: (value) {
                        setState(() {
                          taxaJuros =
                              double.tryParse(value.replaceAll(',', '.')) ?? 0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                label: 'Prazo (em meses)',
                onChanged: (value) {
                  setState(() {
                    prazoMeses = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 24),
              CustomCalcButton(
                texto: 'Calcular',
                onPressed: () {
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
                        valorFinanciado: valorEmprestimo + valorSegurosETaxas,
                        taxaJuros: taxaJuros,
                        prazoFinanciamento: prazoMeses,
                        tipoDeTaxa: _tipoDeTaxaSelecionada,
                        valorParcelaInicialPrice: valorParcelaPrice,
                        valorParcelaInicialSAC: valorParcelaSAC[0],
                        valorParcelaFinalPrice: valorParcelaPrice,
                        valorParcelaFinalSAC: valorParcelaSAC[prazoMeses - 1],
                        valorTotalPagoPrice: valorParcelaPrice * prazoMeses,
                        valorTotalJurosPrice: (valorParcelaPrice * prazoMeses) -
                            (valorEmprestimo + valorSegurosETaxas),
                        valorTotalPagoSAC: valorParcelaSAC.reduce(
                            (valorAtual, elemento) => valorAtual + elemento),
                        valorTotalJurosSAC: valorParcelaSAC.reduce(
                                (valorAtual, elemento) =>
                                    valorAtual + elemento) -
                            (valorEmprestimo + valorSegurosETaxas),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
