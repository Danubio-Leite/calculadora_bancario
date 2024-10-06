import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../providers/ofertas_provider.dart';
import 'tela_exibicao_ofertas_salvas.dart';

class TelaOfertasSalvas extends StatefulWidget {
  const TelaOfertasSalvas({super.key});

  @override
  State<TelaOfertasSalvas> createState() => _TelaOfertasSalvasState();
}

class _TelaOfertasSalvasState extends State<TelaOfertasSalvas> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OfertaProvider>(context, listen: false).loadOfertas();
    });
  }

  @override
  Widget build(BuildContext context) {
    var ofertasSalvas = Provider.of<OfertaProvider>(context).ofertas;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minhas Ofertas',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
          overflow: TextOverflow.fade,
        ),
      ),
      body: ofertasSalvas.isEmpty
          ? const Center(child: Text('Nenhuma oferta salva'))
          : ListView.builder(
              itemCount: ofertasSalvas.length,
              itemBuilder: (context, index) {
                var oferta = ofertasSalvas[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        oferta.label,
                        style: const TextStyle(fontSize: 20),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            oferta.produto,
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy', 'pt_BR')
                                .format(DateTime.parse(oferta.data)),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TelaOfertaDetalhes(
                                    oferta: oferta,
                                    index: index,
                                  )),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
