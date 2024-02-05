import 'package:calculadora_bancario/components/insert_field.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
  String? email; // Adicione esta linha

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
      path: email, // Altere para o email do usuário
      query:
          'subject=Sugestão de Nova Função&body=Nome: $nome\nTelefone: $telefone\nSugestão: $sugestao',
    );

    if (await canLaunch(params.toString())) {
      await launch(params.toString());
    } else {
      throw 'Could not launch $params';
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
              CustomInsertField(
                label: 'Nome',
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
              const SizedBox(
                height: 16,
              ),
              CustomInsertField(
                maskFormatter: MaskTextInputFormatter(
                  mask: '(##) #####-####',
                  filter: {"#": RegExp(r'[0-9]')},
                ),
                keyboardType: TextInputType.phone,
                label: 'Telefone',
                onSaved: (value) {
                  telefone = value;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              CustomInsertField(
                label: 'Email',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  // Você pode adicionar mais validações aqui, como verificar se o valor contém um @
                  return null;
                },
                onSaved: (value) {
                  email = value;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              CustomInsertField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira sua sugestão';
                  }
                  return null;
                },
                onSaved: (value) {
                  sugestao = value;
                },
                label: 'Sugestão',
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  _enviarSugestao();
                  Navigator.pop(context);
                },
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
