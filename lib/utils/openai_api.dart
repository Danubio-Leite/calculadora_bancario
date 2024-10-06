import 'package:dio/dio.dart';
import '../config.dart';

class OpenAIService {
  final Dio _dio = Dio();
  final String _apiKey = openAIAPIKey; // Substitua pela sua chave de API

  // Método que gera o texto da oferta com base nos dados fornecidos
  Future<String> generateOffer(Map<String, dynamic> dadosProduto) async {
    const String apiUrl = 'https://api.openai.com/v1/chat/completions';
    try {
      print('Iniciando chamada para API com os seguintes dados: $dadosProduto');
      print('URL da API: $apiUrl');

      final response = await _dio.post(
        apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': 'gpt-4o-mini', // Verifique se o modelo está correto
          'messages': [
            {
              'role': 'system',
              'content': _buildPrompt(dadosProduto), // Função que cria o prompt
            },
          ],
          'max_tokens': 500, // Limita o tamanho da resposta
          'temperature': 0.7, // Ajusta a criatividade da resposta
        },
      );

      print('Resposta recebida: ${response.data}');

      if (response.statusCode == 200) {
        // Retorna o texto da oferta gerada
        final offerText =
            response.data['choices'][0]['message']['content'].toString().trim();
        print('Oferta gerada com sucesso: $offerText');
        return offerText;
      } else {
        print('Erro ao gerar oferta: Código de status ${response.statusCode}');
        throw Exception('Erro ao gerar oferta: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao se comunicar com a API: $e');
      throw Exception('Erro ao se comunicar com a API: $e');
    }
  }

  // Função que constrói o prompt para a API da OpenAI
  String _buildPrompt(Map<String, dynamic> dadosProduto) {
    String nomeCliente = dadosProduto['nomeCliente'] ?? 'Cliente';
    String tomConversa = dadosProduto['tomConversa'] ?? 'Formal';
    String genero = dadosProduto['genero'] ?? 'Neutro';
    String estagioOferta = dadosProduto['estagioOferta'] ?? 'Inicial';
    String instituicao = dadosProduto['instituicao'] ?? 'Instituição';
    String produto = dadosProduto['produto'] ?? 'Produto';

    print('Construindo prompt com os seguintes dados:');
    print(
        'Nome do Cliente: $nomeCliente, Tom da Conversa: $tomConversa, Gênero: $genero, Estágio da Oferta: $estagioOferta, Instituição: $instituicao, Produto: $produto');

    String prompt = "Gere uma oferta de $produto para o cliente $nomeCliente. "
        "A conversa deve ter um tom $tomConversa e o gênero do cliente é $genero. "
        "Estamos no estágio $estagioOferta da oferta. O produto é oferecido pela instituição $instituicao. ";

    if (produto == 'Consórcio') {
      prompt +=
          "O valor da carta é de ${dadosProduto['valorCarta']} reais, com um lance de ${dadosProduto['valorLance']} reais. "
          "A parcela após o lance é de ${dadosProduto['parcelaLance']} reais, com uma parcela de financiamento equivalente a ${dadosProduto['parcelaEquivalente']} reais. "
          "A taxa de administração é ${dadosProduto['taxaAdm']}%.";
    } else if (produto == 'Seguro de Vida') {
      prompt += "A parcela do seguro é de ${dadosProduto['parcela']} reais. "
          "O cliente tem filhos: ${dadosProduto['temFilhos'] ? 'Sim' : 'Não'} e possui valor significativo em investimentos: ${dadosProduto['valorSignificativo'] ? 'Sim' : 'Não'}.";
    } else if (produto == 'Previdência') {
      prompt +=
          "O aporte inicial é de ${dadosProduto['aporteInicial']} reais, com aportes mensais de ${dadosProduto['aportesMensais']} reais. "
          "O cliente escolheu a modalidade ${dadosProduto['modalidade']} e possui uma carência de ${dadosProduto['carencia']} meses. "
          "A idade do cliente é ${dadosProduto['idade']}, com uma rentabilidade do fundo de ${dadosProduto['rentabilidadeFundo']}% e uma rentabilidade da poupança de ${dadosProduto['rentabilidadePoupanca']}%. "
          "O foco do cliente é ${dadosProduto['focoCliente']}.";
    }

    prompt += " Utilize linguagem adequada ao perfil do cliente.";
    print('Prompt construído: $prompt');
    return prompt;
  }
}
