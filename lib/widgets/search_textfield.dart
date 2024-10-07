import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final ValueChanged<String>? onTextChanged;
  final ValueChanged<String>? onSubmitButton;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  const SearchTextField({
    Key? key,
    required this.textEditingController,
    required this.hintText,
    this.onTextChanged,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.words,
    this.onSubmitButton,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: textEditingController,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      onChanged: onTextChanged,
      onSubmitted: onSubmitButton,
      decoration: InputDecoration.collapsed(
        enabled: enabled,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.75),
        ),
      ),
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      textInputAction: TextInputAction.search,
    );
  }
}
