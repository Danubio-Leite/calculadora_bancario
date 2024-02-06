import 'dart:math';

double calcularIof(double valorEmprestimo, int prazoMeses) {
  double aliquotaDiaria = 0.0082 / 100;
  double aliquotaAdicional = 0.38 / 100;
  double iof = valorEmprestimo * (pow(1 + aliquotaDiaria, prazoMeses * 30) - 1);
  iof += valorEmprestimo * aliquotaAdicional;
  return iof;
}

double calcularPagamentoMensal(double valorEmprestimo, double taxaJuros,
    int prazoMeses, DateTime dataPrimeiraParcela) {
  double jurosMensais = taxaJuros / 100;
  double iof = calcularIof(valorEmprestimo, prazoMeses);

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

class CalculadoraAposentadoria {
  static double calcularMontante(
      double aplicacaoInicial,
      double aplicacaoMensal,
      double taxaJuros,
      int periodo,
      String jurosSelecionado,
      String periodoSelecionado) {
    double taxa = taxaJuros / 100;
    if (jurosSelecionado == 'a.a.') {
      taxa /= 12;
    }
    if (periodoSelecionado == 'Anos') {
      periodo *= 12;
    }

    double montante = aplicacaoInicial;
    for (int i = 0; i < periodo; i++) {
      montante += aplicacaoMensal;
      montante += montante * taxa;
    }

    return montante;
  }
}
