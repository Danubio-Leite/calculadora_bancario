import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/insert_field.dart';
import '../components/custom_calc_button.dart';

class TelaRegraDeTres extends StatefulWidget {
  const TelaRegraDeTres({super.key});

  @override
  TelaRegraDeTresState createState() => TelaRegraDeTresState();
}

class TelaRegraDeTresState extends State<TelaRegraDeTres> {
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: '');
  double valor1 = 0;
  double valor2 = 0;
  double valor3 = 0;
  double resultado = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Regra de Três',
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
                  title: const Text('Sobre a Calculadora de Regra de Três'),
                  content: const SingleChildScrollView(
                    child: Text(
                        'Ferramenta matemática utilizada para encontrar um valor desconhecido com base em proporções conhecidas.'),
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
                const Text(
                  'Valor 1 está para Valor 2',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  label: 'Valor 1',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um valor';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      valor1 = double.tryParse(value.replaceAll(',', '.')) ?? 0;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  label: 'Valor 2',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um valor';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      valor2 = double.tryParse(value.replaceAll(',', '.')) ?? 0;
                    });
                  },
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  label: 'Valor 3',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, insira um valor';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      valor3 = double.tryParse(value.replaceAll(',', '.')) ?? 0;
                    });
                  },
                ),
                if (resultado > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: FittedBox(
                      child: Row(
                        children: [
                          const Text(
                            'Assim como o Valor 3 está para:',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            formatador.format(resultado),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (resultado == 0)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Assim como o Valor 3 está para:',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                CustomCalcButton(
                  texto: 'Calcular',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        resultado = ((valor2 * valor3) / valor1);
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 140,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
