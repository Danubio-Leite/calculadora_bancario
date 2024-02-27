import 'package:flutter/material.dart';

import 'custom_calc_button.dart';

class DialogSalvarSimulacao extends StatelessWidget {
  TextEditingController controller;
  String label;
  DialogSalvarSimulacao(
      {super.key, required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(24),
      title: const Text('Dê um título para essa simulação:',
          style: TextStyle(
            fontSize: 16,
          )),
      content: TextField(
        // focusNode: focusNode,
        decoration: const InputDecoration(
          hintText: 'Ex: Simulação 01',
          contentPadding: EdgeInsets.all(8),
          border: OutlineInputBorder(),
        ),
        controller: controller,
        onChanged: (value) {
          label = value;
        },
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: CustomCalcButton(
                padding: const EdgeInsets.symmetric(vertical: 8),
                backgroundColor: const Color.fromARGB(255, 187, 187, 187),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                texto: 'Cancelar',
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: CustomCalcButton(
                padding: const EdgeInsets.symmetric(vertical: 8),
                onPressed: () {
                  Navigator.of(context).pop(label ?? DateTime.now().toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Simulação salva com sucesso!'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Color.fromARGB(255, 116, 185, 119),
                    ),
                  );
                },
                texto: 'Salvar',
              ),
            ),
          ],
        ),
      ],
    );
    ;
  }
}
