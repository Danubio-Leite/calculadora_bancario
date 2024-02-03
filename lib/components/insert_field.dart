import 'package:flutter/material.dart';

class CustomInsertField extends StatelessWidget {
  final String label;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;

  const CustomInsertField({
    Key? key,
    required this.label,
    this.prefix,
    this.suffix,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefix,
        suffixIcon: suffix,
        border: OutlineInputBorder(),
      ),
    );
  }
}
