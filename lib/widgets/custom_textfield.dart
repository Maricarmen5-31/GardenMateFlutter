import 'package:flutter/material.dart';
import 'package:garden_mate/utils/constants.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController? controller; // Agrega este parámetro
  final IconData icon;
  final bool obscureText;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSaved;

  const CustomTextfield({
    Key? key,
    this.controller, // Modifica aquí
    required this.icon,
    required this.obscureText,
    required this.hintText,
    this.validator,
    this.onChanged,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Usa el controller aquí
      obscureText: obscureText,
      style: const TextStyle(
        color: Constants.blackColor,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(icon, color: Constants.blackColor.withOpacity(.3)),
        hintText: hintText,
      ),
      cursorColor: Constants.blackColor.withOpacity(.5),
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved != null ? (value) => onSaved!(value!) : null,
    );
  }
}
