import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/oferta_model.dart';
import '../../providers/ofertas_provider.dart';

class TelaGeradorOfertasExibicao extends StatelessWidget {
  final String ofertaGerada;

  const TelaGeradorOfertasExibicao({Key? key, required this.ofertaGerada})
      : super(key: key);

  void _compartilharOferta(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;

    Share.share(
      ofertaGerada,
      subject: 'Confira esta oferta!',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  void _salvarOferta(BuildContext context) {
    final oferta = Oferta(
      //id unico para cada oferta
      id: DateTime.now().millisecondsSinceEpoch,
      label:
          "Oferta Personalizada", // Exemplo de label, você pode customizar como quiser
      texto: ofertaGerada,
      data: DateTime.now().toIso8601String(),
      produto: "Produto Exemplo", // Exemplo de produto, pode ser customizado
    );

    Provider.of<OfertaProvider>(context, listen: false).addOferta(oferta);
    print('Oferta salva com sucesso!');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Oferta salva com sucesso!')),
    );
  }

  void _copiarOferta(BuildContext context) {
    Clipboard.setData(ClipboardData(text: ofertaGerada));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Oferta copiada para a área de transferência')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oferta Gerada'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  ofertaGerada,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Salvar'),
              onPressed: () => _salvarOferta(context),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Compartilhar'),
              onPressed: () => _compartilharOferta(context),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copiar'),
              onPressed: () => _copiarOferta(context),
            ),
          ],
        ),
      ),
    );
  }
}
