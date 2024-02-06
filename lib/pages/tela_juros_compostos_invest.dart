import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();
  String _periodoSelecionado = 'Meses';
  String _jurosSelecionado = 'a.m.';
  int periodo = 0;
  double aplicacaoInicial = 0;
  double aplicacaoMensal = 0;
  double taxaJuros = 0;
  double resultado = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juros Compostos - Investimento'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            CustomInsertField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              label: 'Aplicação inicial',
              prefix: const Text('R\$ '),
              onChanged: (value) {
                setState(() {
                  aplicacaoInicial = double.tryParse(
                          value.replaceAll('.', ',').replaceAll(',', '.')) ??
                      0;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomInsertField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              label: 'Aplicação mensal',
              prefix: const Text('R\$ '),
              onChanged: (value) {
                setState(() {
                  aplicacaoMensal = double.tryParse(
                          value.replaceAll('.', ',').replaceAll(',', '.')) ??
                      0;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomInsertField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    label: 'Taxa de juros estimada',
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
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    label: 'Período',
                    onChanged: (value) {
                      setState(() {
                        periodo = int.tryParse(value) ?? 0;
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
                setState(() {
                  resultado = CalculadoraAposentadoria.calcularMontante(
                    aplicacaoInicial,
                    aplicacaoMensal,
                    taxaJuros,
                    periodo,
                    _jurosSelecionado,
                    _periodoSelecionado,
                  );
                });
              },
            ),
            const SizedBox(height: 24),
            if (resultado > 0)
              ResultCard(
                titulo: 'Montante após o período:',
                resultado: 'R\$ ${resultado.toStringAsFixed(2)}',
              ),
          ],
        ),
      ),
    );
  }
}
