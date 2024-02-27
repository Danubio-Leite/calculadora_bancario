import 'package:calculadora_bancario/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'pages/tela_inicial.dart';
import 'providers/indices_provider.dart';
import 'providers/simulacoes_salvas_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IndicesProvider()),
        ChangeNotifierProvider(create: (context) => TabelaProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora do Bancário',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyMedium: GoogleFonts.nunito(textStyle: textTheme.bodyMedium),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 159, 185, 227),
          foregroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)
            .copyWith(background: const Color.fromARGB(255, 235, 239, 251)),
      ),
      home: FutureBuilder(
        future:
            Provider.of<TabelaProvider>(context, listen: false).loadTabelas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const TelaInicial();
          } else {
            return const CircularProgressIndicator(); // Mostra um indicador de carregamento enquanto os dados estão sendo carregados
          }
        },
      ),
    );
  }
}
