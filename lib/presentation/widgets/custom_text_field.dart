import 'package:flutter/material.dart';
import '../../core/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController cnt;
  final TextInputType typeKB;
  final IconData? icon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.cnt,
    this.typeKB = TextInputType.text,
    this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: colorSecundario),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: cnt,
          keyboardType: typeKB,
          validator: validator,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: icon != null ? Icon(icon, color: colorPrincipal) : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            fillColor: Colors.grey.shade50,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: colorPrincipal, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: colorError),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: colorError, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}