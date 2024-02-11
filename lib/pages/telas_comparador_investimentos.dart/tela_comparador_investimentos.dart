import 'package:calculadora_bancario/components/custom_calc_button.dart';
import 'package:flutter/material.dart';
import '../../components/insert_field.dart';
import '../../utils/calc_utils.dart';
import 'tela_tabela_comparador_investimentos.dart';

class TelaComparadorInvestimentos extends StatefulWidget {
  const TelaComparadorInvestimentos({super.key});

  @override
  _TelaComparadorInvestimentosState createState() =>
      _TelaComparadorInvestimentosState();
}

class _TelaComparadorInvestimentosState
    extends State<TelaComparadorInvestimentos> {
  final nomeInvestimentoController1 = TextEditingController();
  final nomeInvestimentoController2 = TextEditingController();
  final rentabilidadeInvestimentoController1 = TextEditingController();
  final rentabilidadeInvestimentoController2 = TextEditingController();
  final aplicacaoInicialController = TextEditingController();
  final aplicacaoMensalController = TextEditingController();

  @override
  void dispose() {
    nomeInvestimentoController1.dispose();
    nomeInvestimentoController2.dispose();
    rentabilidadeInvestimentoController1.dispose();
    rentabilidadeInvestimentoController2.dispose();
    aplicacaoInicialController.dispose();
    aplicacaoMensalController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparador Investimentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sobre o Comprador de Investimentos'),
                  content: const SingleChildScrollView(
                    child: Text(
                        'Este comparador tem como objetivo disponibilizar uma tabela comparativa entre dois investimentos.'),
                  ),
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
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 6),
                const Text('Valor Investido:', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 6),
                CustomInsertField(
                  controller: aplicacaoInicialController,
                  label: 'Aplicação inicial',
                  prefix: const Text('R\$'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: aplicacaoMensalController,
                  label: 'Aportes Mensais (Opcional)',
                  prefix: const Text('R\$'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 6),
                const Text('Investimento 01:', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 6),
                CustomInsertField(
                  controller: nomeInvestimentoController1,
                  label: 'Nome do Investimento',
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: rentabilidadeInvestimentoController1,
                  label: 'Rentabilidade Anual',
                  suffix: const Text('%'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 6),
                const Text('Investimento 02:', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 6),
                CustomInsertField(
                  controller: nomeInvestimentoController2,
                  label: 'Nome do Investimento',
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: rentabilidadeInvestimentoController2,
                  label: 'Rentabilidade Anual',
                  suffix: const Text('%'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                CustomCalcButton(
                  texto: 'Calcular',
                  onPressed: () {
                    final rentabilidadeInvestimento01 = double.tryParse(
                            rentabilidadeInvestimentoController1.text
                                .replaceAll(',', '.')) ??
                        0;
                    final rentabilidadeInvestimento02 = double.tryParse(
                            rentabilidadeInvestimentoController2.text
                                .replaceAll(',', '.')) ??
                        0;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaTabelaComparadorInvestimentos(
                          nomeInvestimento01: nomeInvestimentoController1.text,
                          nomeInvestimento02: nomeInvestimentoController2.text,
                          rentabilidadeInvestimento01:
                              rentabilidadeInvestimento01,
                          rentabilidadeInvestimento02:
                              rentabilidadeInvestimento02,
                          aplicacaoInicial01: double.tryParse(
                                  aplicacaoInicialController.text
                                      .replaceAll(',', '.')) ??
                              0,
                          aplicacaoInicial02: double.tryParse(
                                  aplicacaoInicialController.text
                                      .replaceAll(',', '.')) ??
                              0,
                          aplicacaoMensal01: double.tryParse(
                                  aplicacaoMensalController.text
                                      .replaceAll(',', '.')) ??
                              0,
                          aplicacaoMensal02: double.tryParse(
                                  aplicacaoMensalController.text
                                      .replaceAll(',', '.')) ??
                              0,
                          montante12Meses01:
                              CalculadoraJurosCompostosInvestimentos
                                  .calcularMontante(
                            double.tryParse(aplicacaoInicialController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            double.tryParse(aplicacaoMensalController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            rentabilidadeInvestimento01,
                            1,
                            'a.a.',
                            'Anos',
                          ),
                          montante12Meses02:
                              CalculadoraJurosCompostosInvestimentos
                                  .calcularMontante(
                            double.tryParse(aplicacaoInicialController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            double.tryParse(aplicacaoMensalController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            rentabilidadeInvestimento02,
                            1,
                            'a.a.',
                            'Anos',
                          ),
                          montante02Anos01:
                              CalculadoraJurosCompostosInvestimentos
                                  .calcularMontante(
                            double.tryParse(aplicacaoInicialController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            double.tryParse(aplicacaoMensalController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            rentabilidadeInvestimento01,
                            2,
                            'a.a.',
                            'Anos',
                          ),
                          montante02Anos02:
                              CalculadoraJurosCompostosInvestimentos
                                  .calcularMontante(
                            double.tryParse(aplicacaoInicialController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            double.tryParse(aplicacaoMensalController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            rentabilidadeInvestimento02,
                            2,
                            'a.a.',
                            'Anos',
                          ),
                          montante05Anos01:
                              CalculadoraJurosCompostosInvestimentos
                                  .calcularMontante(
                            double.tryParse(aplicacaoInicialController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            double.tryParse(aplicacaoMensalController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            rentabilidadeInvestimento01,
                            5,
                            'a.a.',
                            'Anos',
                          ),
                          montante05Anos02:
                              CalculadoraJurosCompostosInvestimentos
                                  .calcularMontante(
                            double.tryParse(aplicacaoInicialController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            double.tryParse(aplicacaoMensalController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            rentabilidadeInvestimento02,
                            5,
                            'a.a.',
                            'Anos',
                          ),
                          montante10Anos01:
                              CalculadoraJurosCompostosInvestimentos
                                  .calcularMontante(
                            double.tryParse(aplicacaoInicialController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            double.tryParse(aplicacaoMensalController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            rentabilidadeInvestimento01,
                            10,
                            'a.a.',
                            'Anos',
                          ),
                          montante10Anos02:
                              CalculadoraJurosCompostosInvestimentos
                                  .calcularMontante(
                            double.tryParse(aplicacaoInicialController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            double.tryParse(aplicacaoMensalController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            rentabilidadeInvestimento02,
                            10,
                            'a.a.',
                            'Anos',
                          ),
                          montante20Anos01:
                              CalculadoraJurosCompostosInvestimentos
                                  .calcularMontante(
                            double.tryParse(aplicacaoInicialController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            double.tryParse(aplicacaoMensalController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            rentabilidadeInvestimento01,
                            20,
                            'a.a.',
                            'Anos',
                          ),
                          montante20Anos02:
                              CalculadoraJurosCompostosInvestimentos
                                  .calcularMontante(
                            double.tryParse(aplicacaoInicialController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            double.tryParse(aplicacaoMensalController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            rentabilidadeInvestimento02,
                            20,
                            'a.a.',
                            'Anos',
                          ),
                          montante30Anos01:
                              CalculadoraJurosCompostosInvestimentos
                                  .calcularMontante(
                            double.tryParse(aplicacaoInicialController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            double.tryParse(aplicacaoMensalController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            rentabilidadeInvestimento01,
                            30,
                            'a.a.',
                            'Anos',
                          ),
                          montante30Anos02:
                              CalculadoraJurosCompostosInvestimentos
                                  .calcularMontante(
                            double.tryParse(aplicacaoInicialController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            double.tryParse(aplicacaoMensalController.text
                                    .replaceAll(',', '.')) ??
                                0,
                            rentabilidadeInvestimento02,
                            30,
                            'a.a.',
                            'Anos',
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
