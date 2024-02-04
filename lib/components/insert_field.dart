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

  const CustomInsertField({
    Key? key,
    required this.label,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.maskFormatter,
    this.controller,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: maskFormatter != null ? [maskFormatter!] : [],
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: prefix != null
            ? Container(alignment: Alignment.center, width: 48, child: prefix)
            : null,
        suffixIcon: suffix != null
            ? Container(alignment: Alignment.center, width: 48, child: suffix)
            : null,
      ),
      enabled: enabled,
    );
  }
}
