import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/helpers/validator.dart';

enum CustomTextFieldValidator {
  nullCheck,
  phoneNumber,
  email,
  password,
  maxFifty,
}

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final int? minLine;
  final int? maxLine;
  final bool? isReadOnly;
  final List<TextInputFormatter>? formaters;
  final CustomTextFieldValidator? validator;
  final Color? fillColor;
  final Function(dynamic value)? onChange;
  final Widget? prefix;
  final TextInputAction? action;
  final TextInputType? keyboard;
  final Widget? suffix;
  final bool? dense;
  const CustomTextFormField({
    Key? key,
    this.hintText,
    this.controller,
    this.minLine,
    this.maxLine,
    this.formaters,
    this.isReadOnly,
    this.validator,
    this.fillColor,
    this.onChange,
    this.prefix,
    this.keyboard,
    this.action,
    this.suffix,
    this.dense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: formaters,
      textInputAction: action,
      keyboardAppearance: Brightness.light,
      readOnly: isReadOnly ?? false,
      style: const TextStyle(fontSize: 17),
      minLines: minLine ?? 1,
      maxLines: maxLine ?? 1,
      onChanged: onChange,
      validator: (String? value) {
        if (validator == CustomTextFieldValidator.nullCheck) {
          return Validator.nullCheckValidator(value);
        }

        if (validator == CustomTextFieldValidator.maxFifty) {
          if ((value ??= "").length > 50) {
            return "You can enter 50 letters max";
          } else {
            return null;
          }
        }
        // ignore: unrelated_type_equality_checks
        if (validator == CustomTextFieldValidator.values) {
          return Validator.validateString(value);
        }

        return null;
      },
      keyboardType: keyboard,
      decoration: InputDecoration(
          prefix: prefix,
          isDense: dense,
          suffixIcon: suffix,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white, fontSize: 16),
          filled: true,
          // fillColor: fillColor ?? Colors.black,
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1.5, color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1.5, color: Colors.black),
              borderRadius: BorderRadius.circular(10)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(width: 1.5, color: Colors.black),
              borderRadius: BorderRadius.circular(10))),
    );
  }
}
