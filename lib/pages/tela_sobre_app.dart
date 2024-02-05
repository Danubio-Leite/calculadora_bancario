import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaSobreApp extends StatelessWidget {
  const TelaSobreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        title: const Text(
          'Sobre o App',
        ),
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Este aplicativo foi desenvolvido por Danúbio Leite para fins de estudo, qualquer uso prático é de responsabilidade do usuário.',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Dúvidas ou sugestões? Pode mandar um email para danubioalves@gmail.com.',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              text:
                                  'Quer conhecer outros projetos que estou desenvolvendo? Dá uma olhada no meu '),
                          TextSpan(
                            text: 'GitHub',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 16),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchUrl(Uri.parse(
                                    'https://github.com/Danubio-Leite'));
                              },
                          ),
                          const TextSpan(
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                              text: '.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
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
