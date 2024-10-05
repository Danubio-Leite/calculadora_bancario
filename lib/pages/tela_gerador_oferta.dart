import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../components/insert_field.dart';

class TelaGeradorOfertas extends StatefulWidget {
  const TelaGeradorOfertas({Key? key}) : super(key: key);

  @override
  _TelaGeradorOfertasState createState() => _TelaGeradorOfertasState();
}

class _TelaGeradorOfertasState extends State<TelaGeradorOfertas> {
  final nomeClienteController = TextEditingController();
  String? tomConversa = 'Formal'; // Opções: Formal, Informal
  String? genero = 'Masculino'; // Opções: Masculino, Feminino, Neutro
  String? estagioOferta = 'Inicial'; // Opções: Inicial, Fechamento
  String? instituicao = 'BB Consórcio'; // Exemplo de lista de instituições
  String? produtoSelecionado = 'Consórcio'; // Opções de produtos
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
  String? modalidadePrevidencia = 'VGBL'; // Opções: VGBL, PGBL
  String? focoCliente = 'Aposentadoria'; // Opções: Aposentadoria, Investimento

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Preparar dados para a API da OpenAI
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

      // Chamar API da OpenAI com os dados capturados
      // Exemplo: OpenAIService.generateOffer(dadosProduto);
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
                DropdownButtonFormField<String>(
                  value: tomConversa,
                  decoration:
                      const InputDecoration(labelText: 'Tom da Conversa'),
                  items: ['Formal', 'Informal']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => tomConversa = value),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: genero,
                  decoration: const InputDecoration(labelText: 'Gênero'),
                  items: ['Masculino', 'Feminino', 'Neutro']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => genero = value),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: estagioOferta,
                  decoration:
                      const InputDecoration(labelText: 'Estágio da Oferta'),
                  items: ['Inicial', 'Fechamento']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => estagioOferta = value),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: instituicao,
                  decoration: const InputDecoration(labelText: 'Instituição'),
                  items: ['BB Consórcio', 'Brasilprev', 'Porto Seguro']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => instituicao = value),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: produtoSelecionado,
                  decoration: const InputDecoration(labelText: 'Produto'),
                  items: ['Consórcio', 'Seguro de Vida', 'Previdência']
                      .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                      .toList(),
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
                  DropdownButtonFormField<String>(
                    value: modalidadePrevidencia,
                    decoration: const InputDecoration(labelText: 'Modalidade'),
                    items: ['VGBL', 'PGBL']
                        .map((label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ))
                        .toList(),
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
                  DropdownButtonFormField<String>(
                    value: focoCliente,
                    decoration:
                        const InputDecoration(labelText: 'Foco do Cliente'),
                    items: ['Aposentadoria', 'Investimento']
                        .map((label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => focoCliente = value),
                  ),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Gerar Oferta'),
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
