import 'package:calculadora_bancario/components/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../components/custom_home_button.dart';
import 'cdc.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Calculadora',
        title2: 'do Bancário',
        imagePath: 'assets/images/icons/budget1.png',
      ),
      body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          crossAxisCount: 2,
          children: [
            CustomHomeButton(
              imagePath: 'assets/images/icons/money.png',
              buttonText: 'Crédito Direto ao Consumidor',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TelaCalculadoraEmprestimo()),
                );
              },
            ),
            CustomHomeButton(
              imagePath: 'assets/images/icons/budget.png',
              buttonText: 'Poupança para Aposentadoria',
              onPressed: () {},
            ),
            CustomHomeButton(
              imagePath: 'assets/images/icons/profits.png',
              buttonText: 'Comparador de Investimentos',
              onPressed: () {},
            ),
            CustomHomeButton(
              imagePath: 'assets/images/icons/stats.png',
              buttonText: 'Valor Presente Líquido',
              onPressed: () {},
            ),
          ]),
    );
  }
}
