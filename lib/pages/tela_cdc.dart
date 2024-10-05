import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import '../components/custom_calc_button.dart';
import '../components/insert_field.dart';
import '../components/ok_dialog_button.dart';
import '../components/result_card.dart';
import '../utils/calc_utils.dart';

class TelaCalculadoraEmprestimo extends StatefulWidget {
  @override
  _TelaCalculadoraEmprestimoState createState() =>
      _TelaCalculadoraEmprestimoState();
}

class _TelaCalculadoraEmprestimoState extends State<TelaCalculadoraEmprestimo> {
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final valorEmprestimoController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final segurosTaxasController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final taxaJurosController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final prazoMesesController = TextEditingController();
  double valorEmprestimo = 0;
  double taxaJuros = 0;
  int prazoMeses = 0;
  double pagamentoMensal = 0;
  DateTime? dataPrimeiraParcela;
  double valorSeguros = 0;
  final formKey = GlobalKey<FormState>();

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
          'Calculadora CDC',
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
                  title: Text('Sobre a Calculadora CDC'),
                  content: SingleChildScrollView(
                    child: Text(
                        'Esta calculadora permite que você calcule o valor da parcela de um empréstimo, considerando seu valor, seguros/taxas, a taxa de juros mensal e o prazo em meses.\n\nO valor apresentado é aproximado e pode haver variações no momento da contratação.'),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomInsertField(
                  controller: valorEmprestimoController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  label: 'Valor do Empréstimo',
                  prefix: const Text('R\$ '),
                  validator: validateInput,
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: segurosTaxasController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  label: 'Seguros e Taxas',
                  prefix: const Text('R\$ '),
                  validator: validateInput,
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: taxaJurosController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  label: 'Taxa de Juros a.m.',
                  suffix: const Text('%'),
                  validator: validateInput,
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: prazoMesesController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  label: 'Prazo (em meses)',
                  validator: validateInput,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomInsertField(
                          label: 'Data da Primeira Parcela',
                          controller: TextEditingController(
                            text: dataPrimeiraParcela != null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(dataPrimeiraParcela!)
                                : '',
                          ),
                          enabled: false,
                        ),
                      ),
                      const SizedBox(
                          width:
                              16), // Adiciona um espaço entre os campos (data e ícone
                      const Icon(
                        Icons.calendar_today,
                        size: 24,
                      ),
                    ],
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate:
                          DateTime.now().add(const Duration(days: 365 * 5)),
                    );
                    if (date != null) {
                      setState(() {
                        dataPrimeiraParcela = date;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),
                CustomCalcButton(
                  texto: 'Calcular',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      valorEmprestimo = valorEmprestimoController.numberValue;
                      valorSeguros = segurosTaxasController.numberValue;
                      taxaJuros = taxaJurosController.numberValue;
                      prazoMeses = int.tryParse(prazoMesesController.text) ?? 0;
                      if (dataPrimeiraParcela != null) {
                        setState(() {
                          pagamentoMensal = calcularPagamentoMensal(
                              valorEmprestimo + valorSeguros,
                              taxaJuros,
                              prazoMeses,
                              dataPrimeiraParcela!);
                        });
                      } else {
                        // Mostra um alerta se a data da primeira parcela não for selecionada
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Data Inválida'),
                            content: const Text(
                                'Por favor, selecione a data da primeira parcela.'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 24),
                if (pagamentoMensal > 0)
                  ResultCard(
                    titulo: 'Pagamento Mensal',
                    resultado: formatador.format(pagamentoMensal),
                    observacao:
                        'Valor aproximado, informe ao cliente que pode haver variações no momento da contratação.',
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
