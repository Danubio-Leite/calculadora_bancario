import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaSobreApp extends StatelessWidget {
  const TelaSobreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 178, 193, 218),
      appBar: AppBar(
        title: const Text(
          'Sobre o App',
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'A Calculadora do Bancário é um conjunto de ferramentas desenvolvidas para ajudar nas negociações e análises do dia a dia.\n\nVocê pode, de forma simplificada, realizar alguns cálculos financeiros, bem como gerar tabelas comparativas úteis na abordagem de clientes.\n\nOs valores apresentados são aproximações e, em algumas ferramentas, o sistema faz cálculos com juros simples.\n\nSempre que julgar necessário, faça uso de uma calculadora financeira para aferir a acurácia das informações apresentadas.\n\nNo canto superior direito de cada ferramenta há um ícone através do qual são disponibilizadas informações relevantes para o uso e que devem ser levadas em consideração.\n\nAs informações compartilhadas com clientes são de responsabilidade do usuário.\n\nCaso tenha sugestões para novas ferramentas ou ajustes nas atuais, sinta-se à vontade para compartilhar conosco através do ícone "Sugestão de Nova Função" disponível na tela inicial.',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                                text:
                                    'Os ícones utilizados neste aplicativo são provenientes de '),
                            TextSpan(
                              text: 'flaticon.com',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(
                                      Uri.parse('https://www.flaticon.com/'));
                                },
                            ),
                            const TextSpan(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                                text: ''),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Obrigado por baixar nosso app, faça bom uso!',
                          style: TextStyle(color: Colors.black, fontSize: 14)),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Image.asset(
                  'assets/images/blue.png',
                  height: 70,
                ),
              ),
            ]),
      ),
    );
  }
}
