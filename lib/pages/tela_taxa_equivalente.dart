import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../components/custom_calc_button.dart';
import '../components/insert_field.dart';
import '../components/ok_dialog_button.dart';
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
  final taxaJurosController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final periodoOriginalController = TextEditingController();
  final periodoCalculoController = TextEditingController();
  double taxaEquivalente = 0;

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
          'Taxa Equivalente',
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
                builder: (context) => const AlertDialog(
                  title: Text('Sobre a Calculadora de Taxa Equivalente'),
                  content: SingleChildScrollView(
                    child: Text(
                        'Esta calculadora permite que você calcule a taxa de juros equivalente, considerando a taxa de juros original, o período original e o período para cálculo.'),
                  ),
                  actions: [
                    OkButton(),
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
                controller: taxaJurosController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                label: 'Taxa de juros',
                suffix: const Text('%'),
                validator: validateInput,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: CustomInsertField(
                      controller: periodoOriginalController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      label: 'Período original',
                      validator: validateInput,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildDropdownButton('_periodoOriginalSelecionado'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: CustomInsertField(
                      controller: periodoCalculoController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      label: 'Período para cálculo',
                      validator: validateInput,
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
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      taxaEquivalente = calcularTaxaEquivalente(
                        taxaJurosController.numberValue,
                        int.tryParse(periodoOriginalController.text) ?? 0,
                        _periodoOriginalSelecionado,
                        int.tryParse(periodoCalculoController.text) ?? 0,
                        _periodoCalculoSelecionado,
                      );
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              if (taxaEquivalente != 0)
                ResultCard(
                  titulo: 'Taxa equivalente',
                  resultado: '${taxaEquivalente.toStringAsFixed(4)}%',
                ),
              const SizedBox(
                height: 140,
              )
            ],
          )),
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
