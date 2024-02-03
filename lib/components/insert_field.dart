import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomInsertField extends StatelessWidget {
  final String label;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final MaskTextInputFormatter? maskFormatter;

  const CustomInsertField({
    Key? key,
    required this.label,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.maskFormatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}
