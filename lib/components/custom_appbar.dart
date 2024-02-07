import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String title2;
  final String imagePath;

  CustomAppBar(
      {required this.title, required this.imagePath, required this.title2});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 2);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 159, 185, 227),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 159, 185, 227),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(11),
            bottomRight: Radius.circular(11),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                    ), // tamanho do texto
                  ),
                  const SizedBox(
                      height: 8), // adiciona espaço entre os dois títulos
                  Text(
                    title2,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold), // tamanho do texto
                  ),
                ],
              ),
              Image.asset(
                imagePath,
                fit: BoxFit.contain,
                height: kToolbarHeight * 1.5, // altura da imagem
              ),
            ],
          ),
        ),
      ),
    );
  }
}
