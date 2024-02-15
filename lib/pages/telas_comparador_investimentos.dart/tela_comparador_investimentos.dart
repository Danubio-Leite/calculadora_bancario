import 'package:calculadora_bancario/components/custom_calc_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  final rentabilidadeInvestimentoController1 =
      MoneyMaskedTextController(decimalSeparator: ',');
  final rentabilidadeInvestimentoController2 =
      MoneyMaskedTextController(decimalSeparator: ',');
  final aplicacaoInicialController =
      MoneyMaskedTextController(decimalSeparator: ',');
  final aplicacaoMensalController =
      MoneyMaskedTextController(decimalSeparator: ',');

  final _formKey = GlobalKey<FormState>(); // Adicionado

  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, preencha este campo';
    }
    return null;
  }

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
                        'Este comparador tem como objetivo disponibilizar uma tabela comparativa entre dois investimentos.\n\n Os valores apresentados são aproximados, vão variar de acordo com a rentabilidade efetiva e não levam em consideração impostos, taxas e a inflação.'),
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
            key: _formKey, // Adicionado
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
                  validator: validateInput, // Adicionado
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: aplicacaoMensalController,
                  label: 'Aportes Mensais (Opcional)',
                  prefix: const Text('R\$'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: validateInput, // Adicionado
                ),
                const SizedBox(height: 6),
                const Text('Investimento 01:', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 6),
                CustomInsertField(
                  controller: nomeInvestimentoController1,
                  label: 'Nome do Investimento',
                  validator: validateInput, // Adicionado
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: rentabilidadeInvestimentoController1,
                  label: 'Rentabilidade Anual',
                  suffix: const Text('%'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: validateInput, // Adicionado
                ),
                const SizedBox(height: 6),
                const Text('Investimento 02:', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 6),
                CustomInsertField(
                  controller: nomeInvestimentoController2,
                  label: 'Nome do Investimento',
                  validator: validateInput, // Adicionado
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: rentabilidadeInvestimentoController2,
                  label: 'Rentabilidade Anual',
                  suffix: const Text('%'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: validateInput, // Adicionado
                ),
                const SizedBox(height: 16),
                CustomCalcButton(
                  texto: 'Gerar Tabela',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Adicionado
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                    color:
                                        const Color.fromARGB(255, 0, 96, 164),
                                    size: 60,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Configurando Tabela",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 96, 164),
                                    ),
                                  ), // O texto
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      Future.delayed(const Duration(milliseconds: 1500), () {
                        Navigator.of(context).pop();

                        final rentabilidadeInvestimento01 =
                            rentabilidadeInvestimentoController1.numberValue;
                        final rentabilidadeInvestimento02 =
                            rentabilidadeInvestimentoController2.numberValue;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TelaTabelaComparadorInvestimentos(
                              nomeInvestimento01:
                                  nomeInvestimentoController1.text,
                              nomeInvestimento02:
                                  nomeInvestimentoController2.text,
                              rentabilidadeInvestimento01:
                                  rentabilidadeInvestimento01,
                              rentabilidadeInvestimento02:
                                  rentabilidadeInvestimento02,
                              aplicacaoInicial01:
                                  aplicacaoInicialController.numberValue,
                              aplicacaoInicial02:
                                  aplicacaoInicialController.numberValue,
                              aplicacaoMensal01:
                                  aplicacaoMensalController.numberValue,
                              aplicacaoMensal02:
                                  aplicacaoMensalController.numberValue,
                              montante12Meses01:
                                  CalculadoraJurosCompostosInvestimentos
                                      .calcularMontante(
                                aplicacaoInicialController.numberValue,
                                aplicacaoMensalController.numberValue,
                                rentabilidadeInvestimento01,
                                1,
                                'a.a.',
                                'Anos',
                              ),
                              montante12Meses02:
                                  CalculadoraJurosCompostosInvestimentos
                                      .calcularMontante(
                                aplicacaoInicialController.numberValue,
                                aplicacaoMensalController.numberValue,
                                rentabilidadeInvestimento02,
                                1,
                                'a.a.',
                                'Anos',
                              ),
                              montante02Anos01:
                                  CalculadoraJurosCompostosInvestimentos
                                      .calcularMontante(
                                aplicacaoInicialController.numberValue,
                                aplicacaoMensalController.numberValue,
                                rentabilidadeInvestimento01,
                                2,
                                'a.a.',
                                'Anos',
                              ),
                              montante02Anos02:
                                  CalculadoraJurosCompostosInvestimentos
                                      .calcularMontante(
                                aplicacaoInicialController.numberValue,
                                aplicacaoMensalController.numberValue,
                                rentabilidadeInvestimento02,
                                2,
                                'a.a.',
                                'Anos',
                              ),
                              montante05Anos01:
                                  CalculadoraJurosCompostosInvestimentos
                                      .calcularMontante(
                                aplicacaoInicialController.numberValue,
                                aplicacaoMensalController.numberValue,
                                rentabilidadeInvestimento01,
                                5,
                                'a.a.',
                                'Anos',
                              ),
                              montante05Anos02:
                                  CalculadoraJurosCompostosInvestimentos
                                      .calcularMontante(
                                aplicacaoInicialController.numberValue,
                                aplicacaoMensalController.numberValue,
                                rentabilidadeInvestimento02,
                                5,
                                'a.a.',
                                'Anos',
                              ),
                              montante10Anos01:
                                  CalculadoraJurosCompostosInvestimentos
                                      .calcularMontante(
                                aplicacaoInicialController.numberValue,
                                aplicacaoMensalController.numberValue,
                                rentabilidadeInvestimento01,
                                10,
                                'a.a.',
                                'Anos',
                              ),
                              montante10Anos02:
                                  CalculadoraJurosCompostosInvestimentos
                                      .calcularMontante(
                                aplicacaoInicialController.numberValue,
                                aplicacaoMensalController.numberValue,
                                rentabilidadeInvestimento02,
                                10,
                                'a.a.',
                                'Anos',
                              ),
                              montante20Anos01:
                                  CalculadoraJurosCompostosInvestimentos
                                      .calcularMontante(
                                aplicacaoInicialController.numberValue,
                                aplicacaoMensalController.numberValue,
                                rentabilidadeInvestimento01,
                                20,
                                'a.a.',
                                'Anos',
                              ),
                              montante20Anos02:
                                  CalculadoraJurosCompostosInvestimentos
                                      .calcularMontante(
                                aplicacaoInicialController.numberValue,
                                aplicacaoMensalController.numberValue,
                                rentabilidadeInvestimento02,
                                20,
                                'a.a.',
                                'Anos',
                              ),
                              montante30Anos01:
                                  CalculadoraJurosCompostosInvestimentos
                                      .calcularMontante(
                                aplicacaoInicialController.numberValue,
                                aplicacaoMensalController.numberValue,
                                rentabilidadeInvestimento01,
                                30,
                                'a.a.',
                                'Anos',
                              ),
                              montante30Anos02:
                                  CalculadoraJurosCompostosInvestimentos
                                      .calcularMontante(
                                aplicacaoInicialController.numberValue,
                                aplicacaoMensalController.numberValue,
                                rentabilidadeInvestimento02,
                                30,
                                'a.a.',
                                'Anos',
                              ),
                            ),
                          ),
                        );
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 140,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
