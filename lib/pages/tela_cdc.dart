import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa a biblioteca intl para formatar a data
import '../components/custom_calc_button.dart';
import '../components/insert_field.dart';
import '../components/result_card.dart';
import '../utils/calc_utils.dart';

class TelaCalculadoraEmprestimo extends StatefulWidget {
  @override
  _TelaCalculadoraEmprestimoState createState() =>
      _TelaCalculadoraEmprestimoState();
}

class _TelaCalculadoraEmprestimoState extends State<TelaCalculadoraEmprestimo> {
  final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  double valorEmprestimo = 0;
  double taxaJuros = 0;
  int prazoMeses = 0;
  double pagamentoMensal = 0;
  DateTime? dataPrimeiraParcela;
  double valorSeguros = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Empréstimo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sobre a Calculadora de Empréstimo'),
                  content: const Text(
                      'Esta calculadora permite que você calcule o valor da parcela de um empréstimo, considerando o valor do empréstimo, seguros e taxas, a taxa de juros mensal e o prazo em meses.\n\nO valor apresentado é aproximado e pode haver variações no momento da contratação.'),
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
                label: 'Valor do Empréstimo',
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
                label: 'Seguros e Taxas',
                prefix: const Text('R\$ '),
                onChanged: (value) {
                  setState(() {
                    valorSeguros = double.tryParse(
                            value.replaceAll('.', ',').replaceAll(',', '.')) ??
                        0;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomInsertField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                label: 'Taxa de Juros a.m.',
                suffix: const Text('%'),
                onChanged: (value) {
                  setState(() {
                    taxaJuros =
                        double.tryParse(value.replaceAll(',', '.')) ?? 0;
                  });
                },
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
              const SizedBox(height: 16),
              Row(
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
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
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
                ],
              ),
              const SizedBox(height: 24),
              CustomCalcButton(
                texto: 'Calcular',
                onPressed: () {
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
                },
              ),
              const SizedBox(height: 24),
              if (pagamentoMensal > 0)
                ResultCard(
                  titulo: 'Pagamento Mensal',
                  resultado: formatador.format(pagamentoMensal),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
