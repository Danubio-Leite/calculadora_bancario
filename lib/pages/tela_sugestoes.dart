import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaSugestao extends StatefulWidget {
  const TelaSugestao({super.key});

  @override
  _TelaSugestaoState createState() => _TelaSugestaoState();
}

class _TelaSugestaoState extends State<TelaSugestao> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? telefone;
  String? sugestao;

  void _enviarSugestao() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      _launchURL();
    }
  }

  void _launchURL() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'danubioalves@gmail.com',
      query:
          'subject=Sugestão de Nova Função&body=Nome: $nome\nTelefone: $telefone\nSugestão: $sugestao',
    );

    var url = params.toString();
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sugestão de Nova Função'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
                onSaved: (value) {
                  nome = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Telefone'),
                onSaved: (value) {
                  telefone = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Sugestão'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira sua sugestão';
                  }
                  return null;
                },
                onSaved: (value) {
                  sugestao = value;
                },
              ),
              ElevatedButton(
                onPressed: _enviarSugestao,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
