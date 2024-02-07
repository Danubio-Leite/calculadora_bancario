import 'dart:math';

double calcularIof(double valorEmprestimo, double taxaJuros, int prazoMeses,
    DateTime dataPrimeiraParcela, DateTime dataContratacao) {
  double iof = 0.0;
  double aliquotaAdicional = 0.38 / 100;

  double jurosMensais = taxaJuros / 100;
  double pagamentoMensal = (jurosMensais * valorEmprestimo) /
      (1 - pow(1 + jurosMensais, -prazoMeses));

  for (int i = 0; i < prazoMeses; i++) {
    DateTime dataParcela = dataPrimeiraParcela.add(Duration(days: 30 * i));
    int diasCorridos = dataParcela.difference(dataContratacao).inDays;

    double jurosParcela = valorEmprestimo * jurosMensais;
    double principal = pagamentoMensal - jurosParcela;
    valorEmprestimo -= principal;

    double aliquotaDiaria = 0.0082 / 100 * min(diasCorridos, 365);
    iof += principal * aliquotaDiaria;
  }

  iof += valorEmprestimo * aliquotaAdicional;
  print('IOF: $iof');
  return iof;
}

double calcularPagamentoMensal(double valorEmprestimo, double taxaJuros,
    int prazoMeses, DateTime dataPrimeiraParcela) {
  double jurosMensais = taxaJuros / 100;
  double iof = calcularIof(valorEmprestimo, taxaJuros, prazoMeses,
      dataPrimeiraParcela, DateTime.now());

  double montante = valorEmprestimo + iof;

  double pagamentoMensal =
      (jurosMensais * montante) / (1 - pow(1 + jurosMensais, -prazoMeses));

  return pagamentoMensal;
}

double calcularTaxaEquivalente(double taxa, int periodoOriginal,
    String unidadeOriginal, int periodoCalculo, String unidadeCalculo) {
  // Converter a taxa de porcentagem para uma fração
  taxa /= 100;

  // Converter o período original para dias
  if (unidadeOriginal == 'Anos') {
    periodoOriginal *= 360;
  } else if (unidadeOriginal == 'Meses') {
    periodoOriginal *= 30;
  }

  // Converter o período de cálculo para dias
  if (unidadeCalculo == 'Anos') {
    periodoCalculo *= 360;
  } else if (unidadeCalculo == 'Meses') {
    periodoCalculo *= 30;
  }

  // Calcular a taxa equivalente
  double taxaEquivalente = pow(1 + taxa, periodoCalculo / periodoOriginal) - 1;

  // Converter a taxa equivalente de volta para uma porcentagem
  taxaEquivalente *= 100;

  return taxaEquivalente;
}

class CalculadoraJurosCompostosInvestimentos {
  static double calcularMontante(
      double aplicacaoInicial,
      double aplicacaoMensal,
      double taxaJuros,
      int periodo,
      String jurosSelecionado,
      String periodoSelecionado) {
    double taxa = taxaJuros / 100;
    if (jurosSelecionado == 'a.a.') {
      taxa = calcularTaxaEquivalente(taxaJuros, 1, 'Anos', 1, 'Meses') / 100;
    }
    if (periodoSelecionado == 'Anos') {
      periodo *= 12;
    }

    double montante = aplicacaoInicial * pow(1 + taxa, periodo) +
        aplicacaoMensal * ((pow(1 + taxa, periodo) - 1) / taxa);

    return montante;
  }
}
