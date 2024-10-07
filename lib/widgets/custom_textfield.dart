import 'package:flutter/material.dart';

class Customtextfield extends StatelessWidget {
  const Customtextfield({super.key, required this.controller, this.prefixicon, this.suffixIcon,this.isObsecure = false, this.hintText, this.textInputAction = TextInputAction.next, this.textInputType = TextInputType.text, this.textFieldHeight = 60});
  final TextEditingController controller;
  final Widget? prefixicon;
  final Widget? suffixIcon;
  final bool? isObsecure;
  final String? hintText;
  final TextInputAction? textInputAction;
  final TextInputType ? textInputType;
  final double? textFieldHeight;

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      height: textFieldHeight,
      child: TextFormField(
        style: const TextStyle(color: Colors.black87,letterSpacing: 1, wordSpacing: 1),
        cursorColor: Colors.black,
          controller: controller,
          obscureText: isObsecure!,
          obscuringCharacter: "*",
          textInputAction: textInputAction,
          keyboardType: textInputType,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixicon,
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black87)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black87)),
          )),
    );
  }
}
