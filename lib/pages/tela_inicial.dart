import 'package:calculadora_bancario/components/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../components/custom_home_button.dart';
import 'cdc.dart';
import 'tela_aposentadoria.dart';

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
              imagePath: 'assets/images/icons/piggy-bank.png',
              buttonText: 'Poupança para\n Aposentadoria',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TelaCalculadoraAposentadoria()),
                );
              },
            ),
            CustomHomeButton(
              imagePath: 'assets/images/icons/profits.png',
              buttonText: 'Comparador de\n Investimentos',
              onPressed: () {},
            ),
            CustomHomeButton(
              imagePath: 'assets/images/icons/stats.png',
              buttonText: 'Valor Presente\n Líquido',
              onPressed: () {},
            ),
            CustomHomeButton(
              imagePath: 'assets/images/icons/maths.png',
              buttonText: 'Regra de\n três',
              onPressed: () {},
            ),
            CustomHomeButton(
              imagePath: 'assets/images/icons/accounting.png',
              buttonText: 'Indicadores\n Financeiros',
              onPressed: () {},
            ),
            CustomHomeButton(
              imagePath: 'assets/images/icons/assets.png',
              buttonText: 'Consórcio x\n Financiamento',
              onPressed: () {},
            ),
            CustomHomeButton(
              imagePath: 'assets/images/icons/sheets.png',
              buttonText: 'Gerador de\n Tabelas',
              onPressed: () {},
            ),
            CustomHomeButton(
              imagePath: 'assets/images/icons/idea.png',
              buttonText: 'Sugestão de\n Nova Função',
              onPressed: () {},
            ),
            CustomHomeButton(
              imagePath: 'assets/images/icons/information.png',
              buttonText: 'Sobre o\n App',
              onPressed: () {},
            ),
          ]),
    );
  }
}
