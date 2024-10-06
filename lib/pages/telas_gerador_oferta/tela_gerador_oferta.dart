import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../../components/custom_dropdown.dart';
import '../../components/custom_calc_button.dart';
import '../../components/insert_field.dart';
import '../../utils/openai_api.dart';
import '../telas_ofertas_salvas/tela_ofertas_salvas.dart';
import 'tela_gerador_oferta_exibicao.dart';

class TelaGeradorOfertas extends StatefulWidget {
  const TelaGeradorOfertas({Key? key}) : super(key: key);

  @override
  _TelaGeradorOfertasState createState() => _TelaGeradorOfertasState();
}

class _TelaGeradorOfertasState extends State<TelaGeradorOfertas> {
  final nomeClienteController = TextEditingController();
  String? tomConversa = 'Formal';
  String? genero = 'Masculino';
  String? estagioOferta = 'Inicial';
  String? instituicao = 'BB Consórcio';
  String? produtoSelecionado = 'Consórcio';

  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos específicos de cada produto
  final valorCartaController = MoneyMaskedTextController(decimalSeparator: ',');
  final valorLanceController = MoneyMaskedTextController(decimalSeparator: ',');
  final parcelaLanceController =
      MoneyMaskedTextController(decimalSeparator: ',');
  final parcelaEquivalenteController =
      MoneyMaskedTextController(decimalSeparator: ',');
  final taxaAdmController = MoneyMaskedTextController(decimalSeparator: ',');

  final parcelaSeguroController =
      MoneyMaskedTextController(decimalSeparator: ',');
  final aporteInicialController =
      MoneyMaskedTextController(decimalSeparator: ',');
  final aporteMensalController =
      MoneyMaskedTextController(decimalSeparator: ',');

  final carenciaController = TextEditingController();
  final idadeController = TextEditingController();
  final rentabilidadeFundoController =
      MoneyMaskedTextController(decimalSeparator: ',');
  final rentabilidadePoupancaController =
      MoneyMaskedTextController(decimalSeparator: ',');

  bool temFilhos = false;
  bool valorSignificativo = false;
  String? modalidadePrevidencia = 'VGBL';
  String? focoCliente = 'Aposentadoria';

  @override
  void dispose() {
    nomeClienteController.dispose();
    valorCartaController.dispose();
    valorLanceController.dispose();
    parcelaLanceController.dispose();
    parcelaEquivalenteController.dispose();
    taxaAdmController.dispose();
    parcelaSeguroController.dispose();
    aporteInicialController.dispose();
    aporteMensalController.dispose();
    carenciaController.dispose();
    idadeController.dispose();
    rentabilidadeFundoController.dispose();
    rentabilidadePoupancaController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> dadosProduto = {
        'nomeCliente': nomeClienteController.text,
        'tomConversa': tomConversa,
        'genero': genero,
        'estagioOferta': estagioOferta,
        'instituicao': instituicao,
        'produto': produtoSelecionado,
        if (produtoSelecionado == 'Consórcio') ...{
          'valorCarta': valorCartaController.numberValue,
          'valorLance': valorLanceController.numberValue,
          'parcelaLance': parcelaLanceController.numberValue,
          'parcelaEquivalente': parcelaEquivalenteController.numberValue,
          'taxaAdm': taxaAdmController.numberValue,
        },
        if (produtoSelecionado == 'Seguro de Vida') ...{
          'parcela': parcelaSeguroController.numberValue,
          'temFilhos': temFilhos,
          'valorSignificativo': valorSignificativo,
        },
        if (produtoSelecionado == 'Previdência') ...{
          'aporteInicial': aporteInicialController.numberValue,
          'aportesMensais': aporteMensalController.numberValue,
          'modalidade': modalidadePrevidencia,
          'carencia': carenciaController.text,
          'idade': idadeController.text,
          'rentabilidadeFundo': rentabilidadeFundoController.numberValue,
          'rentabilidadePoupanca': rentabilidadePoupancaController.numberValue,
          'focoCliente': focoCliente,
        },
      };

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        final ofertaGerada = await OpenAIService().generateOffer(dadosProduto);

        Navigator.pop(context); // Fechar o diálogo de carregamento

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TelaGeradorOfertasExibicao(ofertaGerada: ofertaGerada),
          ),
        );
      } catch (e) {
        Navigator.pop(context); // Fechar o diálogo de carregamento
        print('Erro ao gerar oferta: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerador de Ofertas'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomCalcButton(
                    backgroundColor: const Color.fromARGB(255, 183, 207, 250),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TelaOfertasSalvas()));
                    },
                    texto: 'Ofertas Salvas'),
                const SizedBox(height: 16),
                CustomInsertField(
                  label: 'Nome do Cliente',
                  controller: nomeClienteController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o nome do cliente';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdownField(
                  labelText: 'Tom da Conversa',
                  value: tomConversa,
                  options: const ['Formal', 'Informal'],
                  onChanged: (value) => setState(() => tomConversa = value),
                ),
                const SizedBox(height: 16),
                CustomDropdownField(
                  labelText: 'Gênero',
                  value: genero,
                  options: const ['Masculino', 'Feminino', 'Neutro'],
                  onChanged: (value) => setState(() => genero = value),
                ),
                const SizedBox(height: 16),
                CustomDropdownField(
                  labelText: 'Estágio da Oferta',
                  value: estagioOferta,
                  options: const ['Inicial', 'Fechamento'],
                  onChanged: (value) => setState(() => estagioOferta = value),
                ),
                const SizedBox(height: 16),
                CustomDropdownField(
                  labelText: 'Instituição',
                  value: instituicao,
                  options: const ['BB Consórcio', 'Brasilprev', 'Porto Seguro'],
                  onChanged: (value) => setState(() => instituicao = value),
                ),
                const SizedBox(height: 16),
                CustomDropdownField(
                  labelText: 'Produto',
                  value: produtoSelecionado,
                  options: const ['Consórcio', 'Seguro de Vida', 'Previdência'],
                  onChanged: (value) => setState(() {
                    produtoSelecionado = value;
                  }),
                ),
                const SizedBox(height: 16),
                if (produtoSelecionado == 'Consórcio') ...[
                  CustomInsertField(
                    label: 'Valor da Carta',
                    controller: valorCartaController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomInsertField(
                    label: 'Valor do Lance',
                    controller: valorLanceController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomInsertField(
                    label: 'Parcela Após o Lance',
                    controller: parcelaLanceController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomInsertField(
                    label: 'Parcela de Financiamento Equivalente',
                    controller: parcelaEquivalenteController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomInsertField(
                    label: 'Taxa de Administração ao Mês',
                    controller: taxaAdmController,
                    keyboardType: TextInputType.number,
                  ),
                ],
                if (produtoSelecionado == 'Seguro de Vida') ...[
                  CustomInsertField(
                    label: 'Parcela',
                    controller: parcelaSeguroController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Tem filhos?'),
                    value: temFilhos,
                    onChanged: (value) {
                      setState(() {
                        temFilhos = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title:
                        const Text('Tem valor significativo em investimentos?'),
                    value: valorSignificativo,
                    onChanged: (value) {
                      setState(() {
                        valorSignificativo = value;
                      });
                    },
                  ),
                ],
                if (produtoSelecionado == 'Previdência') ...[
                  CustomInsertField(
                    label: 'Aporte Inicial',
                    controller: aporteInicialController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomInsertField(
                    label: 'Aportes Mensais',
                    controller: aporteMensalController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomDropdownField(
                    labelText: 'Modalidade',
                    value: modalidadePrevidencia,
                    options: const ['VGBL', 'PGBL'],
                    onChanged: (value) =>
                        setState(() => modalidadePrevidencia = value),
                  ),
                  const SizedBox(height: 16),
                  CustomInsertField(
                    label: 'Carência',
                    controller: carenciaController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomInsertField(
                    label: 'Idade',
                    controller: idadeController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomInsertField(
                    label: 'Rentabilidade do Fundo (12 meses)',
                    controller: rentabilidadeFundoController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomInsertField(
                    label: 'Rentabilidade da Poupança (12 meses)',
                    controller: rentabilidadePoupancaController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomDropdownField(
                    labelText: 'Foco do Cliente',
                    value: focoCliente,
                    options: const ['Aposentadoria', 'Investimento'],
                    onChanged: (value) => setState(() => focoCliente = value),
                  ),
                ],
                const SizedBox(height: 16),
                CustomCalcButton(
                  onPressed: _submitForm,
                  texto: 'Gerar Oferta',
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}