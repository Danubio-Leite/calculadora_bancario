import 'package:flutter/material.dart';
import '../components/custom_calc_button.dart';
import '../components/insert_field.dart';
import '../components/result_card.dart';
import '../utils/calc_utils.dart';

class TelaTaxaEquivalente extends StatefulWidget {
  const TelaTaxaEquivalente({super.key});

  @override
  _TelaTaxaEquivalenteState createState() => _TelaTaxaEquivalenteState();
}

class _TelaTaxaEquivalenteState extends State<TelaTaxaEquivalente> {
  final _formKey = GlobalKey<FormState>();
  String _periodoOriginalSelecionado = 'Meses';
  String _periodoCalculoSelecionado = 'Meses';
  double taxaJuros = 0;
  double taxaEquivalente = 0;
  int periodoOriginal = 0;
  int periodoCalculo = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Taxa Equivalente'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            CustomInsertField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              label: 'Taxa de juros',
              suffix: const Text('%'),
              onChanged: (value) {
                setState(() {
                  taxaJuros = double.tryParse(value.replaceAll(',', '.')) ?? 0;
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
                    label: 'Período original',
                    onChanged: (value) {
                      setState(() {
                        periodoOriginal = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                _buildDropdownButton('_periodoOriginalSelecionado'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: CustomInsertField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    label: 'Período para cálculo',
                    onChanged: (value) {
                      setState(() {
                        periodoCalculo = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                _buildDropdownButton('_periodoCalculoSelecionado'),
              ],
            ),
            const SizedBox(height: 16),
            CustomCalcButton(
              texto: 'Calcular',
              onPressed: () {
                setState(() {
                  taxaEquivalente = calcularTaxaEquivalente(
                    taxaJuros,
                    periodoOriginal,
                    _periodoOriginalSelecionado,
                    periodoCalculo,
                    _periodoCalculoSelecionado,
                  );
                });
              },
            ),
            if (taxaEquivalente != 0)
              ResultCard(
                titulo: 'Taxa equivalente',
                resultado: '${taxaEquivalente.toStringAsFixed(2)}%',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButton(String selectedValue) {
    String dropdownValue = selectedValue == '_periodoOriginalSelecionado'
        ? _periodoOriginalSelecionado
        : _periodoCalculoSelecionado;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        items: <String>['Anos', 'Meses', 'Dias'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            if (selectedValue == '_periodoOriginalSelecionado') {
              _periodoOriginalSelecionado = newValue!;
            } else {
              _periodoCalculoSelecionado = newValue!;
            }
          });
        },
        underline: const SizedBox(), // remove the default underline
      ),
    );
  }
}
