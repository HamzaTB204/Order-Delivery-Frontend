import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final bool obsecure;
  final String? Function(String?)? validator;
  final Icon prefixIcon;
  const CustomTextFormField(
      {required this.obsecure,
      required this.textEditingController,
      required this.hintText,
      required this.validator,
      required this.prefixIcon,
      super.key});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: Theme.of(context).textTheme.displaySmall,
        cursorColor: Theme.of(context).colorScheme.secondary,
        obscureText: widget.obsecure,
        autocorrect: false,
        controller: widget.textEditingController,
        validator: widget.validator,
        decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide:
                    BorderSide(color: Colors.white, style: BorderStyle.solid)),
            fillColor: Colors.grey.shade900,
            filled: true,
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 3,
                  color: Colors.white54,
                ),
                borderRadius: BorderRadius.circular(13)),
            label: Text(widget.hintText),
            labelStyle: Theme.of(context).textTheme.labelSmall,
            prefixIcon: widget.prefixIcon));
  }
}
