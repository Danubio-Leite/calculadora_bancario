import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import '../components/custom_calc_button.dart';
import '../components/insert_field.dart';
import '../components/result_card.dart';
import '../utils/calc_utils.dart';

class TelaCalculadoraAposentadoria extends StatefulWidget {
  @override
  _TelaCalculadoraAposentadoriaState createState() =>
      _TelaCalculadoraAposentadoriaState();
}

class _TelaCalculadoraAposentadoriaState
    extends State<TelaCalculadoraAposentadoria> {
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final _formKey = GlobalKey<FormState>();
  final aplicacaoInicialController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final aplicacaoMensalController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final taxaJurosController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final periodoController = TextEditingController();
  String _periodoSelecionado = 'Meses';
  String _jurosSelecionado = 'a.m.';
  double resultado = 0;

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
        title: const Text('Juros Compostos - Investimento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sobre a Calculadora de Juros Compostos'),
                  content: const SingleChildScrollView(
                    child: Text(
                        'Esta calculadora permite que você calcule o montante de um investimento, considerando a aplicação inicial, a aplicação mensal, a taxa de juros e o período.\n\nO valor apresentado não leva em consideração a cobrança de impostos.'),
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            CustomInsertField(
              controller: aplicacaoInicialController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              label: 'Aplicação inicial',
              prefix: const Text('R\$ '),
              validator: validateInput,
            ),
            const SizedBox(height: 16),
            CustomInsertField(
              controller: aplicacaoMensalController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              label: 'Aplicação mensal',
              prefix: const Text('R\$ '),
              validator: validateInput,
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomInsertField(
                    controller: taxaJurosController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    label: 'Taxa de juros estimada',
                    suffix: const Text('%'),
                    validator: validateInput,
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
                    value: _jurosSelecionado,
                    items: <String>['a.m.', 'a.a.'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _jurosSelecionado = newValue!;
                      });
                    },
                    underline: const SizedBox(), // remove the default underline
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomInsertField(
                    controller: periodoController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    label: 'Período',
                    validator: validateInput,
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
                    value: _periodoSelecionado,
                    items: <String>['Meses', 'Anos'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _periodoSelecionado = newValue!;
                      });
                    },
                    underline: const SizedBox(), // remove the default underline
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomCalcButton(
              texto: 'Calcular',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  double aplicacaoInicial =
                      aplicacaoInicialController.numberValue;
                  double aplicacaoMensal =
                      aplicacaoMensalController.numberValue;
                  double taxaJuros = taxaJurosController.numberValue;
                  int periodo = int.tryParse(periodoController.text) ?? 0;
                  setState(() {
                    resultado =
                        CalculadoraJurosCompostosInvestimentos.calcularMontante(
                      aplicacaoInicial,
                      aplicacaoMensal,
                      taxaJuros,
                      periodo,
                      _jurosSelecionado,
                      _periodoSelecionado,
                    );
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            if (resultado > 0)
              ResultCard(
                titulo: 'Montante após o período:',
                resultado: formatador.format(resultado),
              ),
          ],
        ),
      ),
    );
  }
}
