import 'package:calculadora_bancario/components/custom_calc_button.dart';
import 'package:calculadora_bancario/components/insert_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaSugestao extends StatefulWidget {
  const TelaSugestao({super.key});

  @override
  _TelaSugestaoState createState() => _TelaSugestaoState();
}

class _TelaSugestaoState extends State<TelaSugestao> {
  final snackBar =
      const SnackBar(content: Text('Recebemos sua sugestão. Obrigado!'));
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? telefone;
  String? sugestao;
  String? email;

  // void _enviarSugestao() {
  //   final form = _formKey.currentState;
  //   if (form!.validate()) {
  //     form.save();
  //     _launchURL();
  //     Navigator.pop(context);
  //   }
  // }
  void _enviarSugestao() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: const Color.fromARGB(255, 0, 96, 164),
                    size: 60,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Enviando sugestão...",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 96, 164),
                    ),
                  ), // O texto
                ),
              ],
            ),
          );
        },
      );
      CollectionReference sugestoes =
          FirebaseFirestore.instance.collection('sugestoes');
      try {
        await sugestoes.add({
          'nome': nome,
          'telefone': telefone,
          'email': email,
          'sugestao': sugestao,
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      } catch (e) {
        Navigator.pop(context);
        const snackBarErro = SnackBar(
            content: Text(
                'Erro ao enviar sugestão. Verifique sua conexão com a internet.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBarErro);
      }
    }
  }

  void _launchURL() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'danubioalves@gmail.com',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Encontrou algum erro ou tem alguma sugestão de nova função? Envie para nós!',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
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
                  label: 'Telefone (Opcional)',
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
                    if (!value.contains('@')) {
                      return 'Por favor, insira um email válido';
                    }
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
                CustomCalcButton(
                    texto: 'Enviar',
                    onPressed: () {
                      _enviarSugestao();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
