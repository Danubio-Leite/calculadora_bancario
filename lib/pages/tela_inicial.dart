import 'package:calculadora_bancario/components/anuncio.dart';
import 'package:calculadora_bancario/components/custom_appbar.dart';
import 'package:calculadora_bancario/pages/telas_consorcio_financiamento/tela_consorcio_financiamento.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../components/custom_home_button.dart';
import '../providers/simulacoes_salvas_provider.dart';
import 'tela_cdc.dart';
import 'tela_indices_offline.dart';
import 'telas_simulacoes_salvas/tela_simulacoes_salvas.dart';
import 'telas_consorcio_consorcio/tela_consorcio_consorcio.dart';
import 'telas_price_sac/tela_price_sac.dart';
import 'telas_comparador_investimentos.dart/tela_comparador_investimentos.dart';
import 'tela_juros_compostos_invest.dart';
import 'tela_indices_economicos.dart';
import 'tela_regra_de_tres.dart';
import 'tela_sobre_app.dart';
import 'tela_sugestoes.dart';
import 'tela_taxa_equivalente.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Calculadora\n do Bancário',
        imagePath: 'assets/images/icons/splash.png',
      ),
      body: Stack(
        children: [
          GridView.count(
              primary: false,
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 15, bottom: 72),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              crossAxisCount: 2,
              children: [
                CustomHomeButton(
                  imagePath: 'assets/images/icons/money.png',
                  buttonText: 'Parcela\n CDC',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TelaCalculadoraEmprestimo()),
                    );
                  },
                ),
                CustomHomeButton(
                  imagePath: 'assets/images/icons/profits.png',
                  buttonText: 'Comparador de\n Investimentos',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const TelaComparadorInvestimentos()),
                    );
                  },
                ),
                CustomHomeButton(
                  imagePath: 'assets/images/icons/assets.png',
                  buttonText: 'Consórcio x\n Financiamento',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TelaFinanciamentoXConsorcio()),
                    );
                  },
                ),
                CustomHomeButton(
                  imagePath: 'assets/images/icons/budget1.png',
                  buttonText: 'Price x\n Sac',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaPriceSac()),
                    );
                  },
                ),
                CustomHomeButton(
                  imagePath: 'assets/images/icons/car.png',
                  buttonText: 'Consórcio x\n Consórcio',
                  onPressed: null,
                ),
                CustomHomeButton(
                  imagePath: 'assets/images/icons/accounting.png',
                  buttonText: 'Indicadores\n Econômicos',
                  onPressed: () async {
                    if (await ConnectivityWrapper.instance.isConnected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TelaIndicesEconomicos()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TelaIndicesEconomicosOffline()),
                      );
                    }
                  },
                ),
                CustomHomeButton(
                  imagePath: 'assets/images/icons/budget.png',
                  buttonText: 'Taxa\n Equivalente',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TelaTaxaEquivalente()),
                    );
                  },
                ),
                CustomHomeButton(
                  imagePath: 'assets/images/icons/piggy-bank.png',
                  buttonText: 'Juros Compostos\n Investimento',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TelaCalculadoraAposentadoria()),
                    );
                  },
                ),
                CustomHomeButton(
                  imagePath: 'assets/images/icons/maths.png',
                  buttonText: 'Regra de\n três',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TelaRegraDeTres()),
                    );
                  },
                ),
                CustomHomeButton(
                  imagePath: 'assets/images/icons/folder.png',
                  buttonText: 'Simulações\nSalvas',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FutureBuilder(
                          future: Future.delayed(
                            const Duration(
                                milliseconds: 1200), // Atraso de 2 segundos
                            () => Provider.of<TabelaProvider>(context,
                                    listen: false)
                                .loadTabelas(),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return const TelaSimulacoesSalvas();
                            } else {
                              return Scaffold(
                                body: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: LoadingAnimationWidget
                                            .staggeredDotsWave(
                                          color: const Color.fromARGB(
                                              255, 0, 96, 164),
                                          size: 60,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Carregando Tabelas",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 0, 96, 164),
                                          ),
                                        ), // O texto
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
                CustomHomeButton(
                  imagePath: 'assets/images/icons/idea.png',
                  buttonText: 'Sugestão de\n Nova Função',
                  onPressed: () async {
                    if (await ConnectivityWrapper.instance.isConnected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TelaSugestao()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Color.fromARGB(255, 176, 49, 40),
                          content: Text(
                            'Essa função requer conexão com a internet.',
                          ),
                        ),
                      );
                    }
                  },
                ),
                CustomHomeButton(
                  imagePath: 'assets/images/icons/information.png',
                  buttonText: 'Sobre o\n App',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TelaSobreApp()),
                    );
                  },
                ),
              ]),
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 0,
            child: const SizedBox(
              height: 50.0,
              child: MeuAnuncio(),
            ),
          ),
        ],
      ),
    );
  }
}
