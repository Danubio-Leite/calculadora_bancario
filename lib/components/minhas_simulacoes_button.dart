import 'package:flutter/material.dart';

class MinhasSimulacoesButton extends StatelessWidget {
  final String categoriaSelecionada;
  final VoidCallback onPressed;
  final String label;
  const MinhasSimulacoesButton({
    super.key,
    required this.categoriaSelecionada,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
            (Set<MaterialState> states) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              );
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (categoriaSelecionada == label) {
                return const Color.fromARGB(255, 83, 149, 202);
              }
              return Colors.white;
            },
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: categoriaSelecionada == label
                ? Colors.white
                : const Color.fromARGB(255, 83, 149, 202),
          ),
        ),
      ),
    );
  }
}
