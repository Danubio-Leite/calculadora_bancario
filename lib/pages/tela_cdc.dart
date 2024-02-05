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
  double valorEmprestimo = 0;
  double taxaJuros = 0;
  int prazoMeses = 0;
  double pagamentoMensal = 0;
  DateTime?
      dataPrimeiraParcela; // Adiciona um novo campo para a data da primeira parcela

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Empréstimo'),
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
                label: 'Taxa de Juros (%)',
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
                      pagamentoMensal = calcularPagamentoMensal(valorEmprestimo,
                          taxaJuros, prazoMeses, dataPrimeiraParcela!);
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
                  resultado: 'R\$ ${pagamentoMensal.toStringAsFixed(2)}',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
