import 'package:calculadora_bancario/components/custom_calc_button.dart';
import 'package:flutter/material.dart';
import '../../components/insert_field.dart';
import 'tela_tabela_consorcio_investimento.dart';

class TelaConsorcioInvestimento extends StatefulWidget {
  @override
  _TelaConsorcioInvestimentoState createState() =>
      _TelaConsorcioInvestimentoState();
}

class _TelaConsorcioInvestimentoState extends State<TelaConsorcioInvestimento> {
  final nomeInvestimentoController = TextEditingController();
  final rentabilidadeInvestimentoController = TextEditingController();
  final prazoConsorcioController = TextEditingController();
  final rentabilidadeConsorcioController = TextEditingController();
  final lanceController = TextEditingController();
  final valorCartaController = TextEditingController();

  @override
  void dispose() {
    nomeInvestimentoController.dispose();
    rentabilidadeInvestimentoController.dispose();
    prazoConsorcioController.dispose();
    rentabilidadeConsorcioController.dispose();
    lanceController.dispose();
    valorCartaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consórcio x Investimento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                      'Sobre o Comparador de Consórcio e Investimento'),
                  content: const SingleChildScrollView(
                    child: Text(
                        'Este comparador tem como objetivo analisar a viabilidade da contratação de consórcio como forma de investimento.\n\nA rentabilidade utilizada para o consórcio é a do Fundo 721 do Banco do Brasil\n\nO cálculo é realizado considerando a rentabilidade média mensal das aplicações nos últimos doze meses, entretanto a rentabilidade obtida no passado não representa garantia de rentabilidade futura.\n\nA ferramenta não leva em consideração a inflação e a tributação dos investimentos.'),
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
                const Center(
                  child: Text('EM DESENVOLVIMENTO',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(height: 6),
                const Text('Investimento:', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 6),
                CustomInsertField(
                  controller: nomeInvestimentoController,
                  label: 'Nome do Investimento',
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: rentabilidadeInvestimentoController,
                  label: 'Rentabilidade (12 meses)',
                  suffix: const Text('%'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                const Text('Consórcio:', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 6),
                CustomInsertField(
                  controller: prazoConsorcioController,
                  label: 'Prazo do Consórcio',
                  suffix: const Text('meses'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: rentabilidadeConsorcioController,
                  label: 'Rentabilidade do Fundo 721 (12 meses)',
                  suffix: const Text('%'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: valorCartaController,
                  label: 'Valor da Carta de Crédito',
                  prefix: const Text('R\$'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                CustomInsertField(
                  controller: lanceController,
                  label: 'Lance do Consórcio',
                  prefix: const Text('R\$'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                CustomCalcButton(
                    texto: 'Calcular',
                    onPressed: () {
                      final valorCartaCredito = double.tryParse(
                              valorCartaController.text.replaceAll(',', '.')) ??
                          0;
                      final prazoConsorcio =
                          int.tryParse(prazoConsorcioController.text) ?? 0;
                      final taxaMensalConsorcio = double.tryParse(
                              rentabilidadeConsorcioController.text
                                  .replaceAll(',', '.')) ??
                          0;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TelaTabelaConsorcioInvestimento(
                            valorInvestimento:
                                valorCartaCredito, // Substitua por seu valor de investimento
                            prazoConsorcio: prazoConsorcio,
                            prazoInvestimento:
                                prazoConsorcio, // Substitua por seu prazo de investimento
                            rendimentoMensalConsorcio: taxaMensalConsorcio,
                            rendimentoMensalInvestimento: taxaMensalConsorcio,
                            valorCartaCredito:
                                valorCartaCredito, // Substitua por seu rendimento mensal de investimento
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
