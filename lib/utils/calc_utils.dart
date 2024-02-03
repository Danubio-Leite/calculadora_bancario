import 'dart:math';

double calcularPagamentoMensal(
    double valorEmprestimo, double taxaJuros, int prazoMeses) {
  double jurosMensais = taxaJuros / 100 / 12;
  double pagamentoMensal = (valorEmprestimo * jurosMensais) /
      (1 - (1 / pow(1 + jurosMensais, prazoMeses)));
  return pagamentoMensal;
}
