import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Empréstimo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomInsertField(
              label: 'Valor do Empréstimo',
              prefix: const Text('R\$ '),
              onChanged: (value) {
                setState(() {
                  valorEmprestimo = double.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomInsertField(
              label: 'Taxa de Juros (%)',
              suffix: const Text('%'),
              onChanged: (value) {
                setState(() {
                  taxaJuros = double.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomInsertField(
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
                setState(() {
                  pagamentoMensal = calcularPagamentoMensal(
                      valorEmprestimo, taxaJuros, prazoMeses);
                });
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
    );
  }
}
