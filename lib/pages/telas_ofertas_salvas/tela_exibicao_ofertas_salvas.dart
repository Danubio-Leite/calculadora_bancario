import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/oferta_model.dart';
import 'package:share_plus/share_plus.dart';

import '../../providers/ofertas_provider.dart';

class TelaOfertaDetalhes extends StatefulWidget {
  final Oferta oferta;
  final int index;

  const TelaOfertaDetalhes(
      {Key? key, required this.oferta, required this.index})
      : super(key: key);

  @override
  _TelaOfertaDetalhesState createState() => _TelaOfertaDetalhesState();
}

class _TelaOfertaDetalhesState extends State<TelaOfertaDetalhes> {
  late TextEditingController _textoController;

  @override
  void initState() {
    super.initState();
    _textoController = TextEditingController(text: widget.oferta.texto);
  }

  @override
  void dispose() {
    _textoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Oferta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textoController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Texto da Oferta',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<OfertaProvider>(context, listen: false)
                          .deleteOferta(widget.oferta.id!);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Excluir'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Share.share(_textoController.text, subject: 'Oferta');
                    },
                    child: const Text('Compartilhar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  var ofertaAtualizada = Oferta(
                    id: widget.oferta.id,
                    label: widget.oferta.label,
                    texto: _textoController.text,
                    data: widget.oferta.data,
                    produto: widget.oferta.produto,
                  );
                  Provider.of<OfertaProvider>(context, listen: false)
                      .updateOferta(ofertaAtualizada);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Oferta atualizada com sucesso')),
                  );
                },
                child: const Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
