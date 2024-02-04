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

class CalculadoraAposentadoria {
  static double calcularMontante(
      double aplicacaoInicial,
      double aplicacaoMensal,
      double taxaJuros,
      int periodo,
      String jurosSelecionado,
      String periodoSelecionado) {
    double taxa = taxaJuros / 100;
    if (jurosSelecionado == 'Anos') {
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
