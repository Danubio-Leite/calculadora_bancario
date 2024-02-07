import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomInsertField extends StatelessWidget {
  final String label;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final MaskTextInputFormatter? maskFormatter;
  final TextEditingController? controller;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType keyboardType;

  const CustomInsertField({
    Key? key,
    required this.label,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.maskFormatter,
    this.controller,
    this.enabled = true,
    this.validator,
    this.onSaved,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      inputFormatters: maskFormatter != null ? [maskFormatter!] : [],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: prefix != null
            ? Container(
                alignment: Alignment.center,
                width: 48,
                child: prefix,
              )
            : null,
        suffixIcon: suffix != null
            ? Container(
                alignment: Alignment.center,
                width: 54,
                padding: const EdgeInsets.only(right: 8),
                child: suffix,
              )
            : null,
      ),
      enabled: enabled,
    );
  }
}
