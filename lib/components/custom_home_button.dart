import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomHomeButton extends StatelessWidget {
  String imagePath;
  String buttonText;
  VoidCallback onPressed;
  CustomHomeButton(
      {super.key,
      required this.imagePath,
      required this.buttonText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: const Color.fromARGB(255, 159, 185, 227),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                AutoSizeText(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
